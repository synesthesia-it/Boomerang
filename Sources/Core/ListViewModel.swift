//
//  ListViewModel.swift
//  NewArch
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
/**
 A `ViewModel` object with the ability of managing list of smaller ViewModels
 
 The main use case scenario of a ListViewModel is for complex sections representing lists of components,
 either homogenous lists like a product list, or heterogeneous sections like a product detail.
 
 Each viewModel in the list is usually converted into a view by some other list-type view component
 (like table and collection views in UIKit).
 
 To populate a list viewModel, usually
 
 1. some user action triggers the `reload()` method, starting data retrieval from the Model layer
 (network calls, database fetch, etc...)
 2. data is eventually ready and structured into a single or multiple entities.
 According to app's business logic, these entities must be converted into an array of `Section` objects,
 each one containing one or many `ViewModel` by setting the `sections` variable
 3. the view waiting for updates is notified of available data through the `onUpdate()` callback
 
 Example:
 
 ```swift
 class ProductsViewModel: ListViewModel {
 let uniqueIdentifier: UniqueIdentifier = UUID()
 let sceneIdentifier: SceneIdentifier = "Some identifier"
 var sections: [Section] = []
 var onUpdate: () -> Void = {}
 
 init() {}
 
 func reload() {
 asyncFetchProducts() { [weak self] products in
 let viewModels = products.map { ProductItemViewModel(product: $0) }
 let firstSection = Section("1", items: viewModels)
 self?.sections = [firstSection]
 self?.onUpdate()
 }
 }
 func selectItem(at indexPath: IndexPath) {
 if let item = self[indexPath] { print(item) }
 }
 }
 ```
 */
public protocol ListViewModel: ViewModel {
    /// The array of available sections
    var sections: [Section] { get set }

    /// A closure that should be set from a View component and called each time a Section update is available
    var onUpdate: () -> Void { get set }

    /// Triggers data reload
    func reload()

    /// Should be called by external views/scenes to trigger some action related to a single element in a list.
    func selectItem(at indexPath: IndexPath)

    func canMoveItem(at indexPath: IndexPath) -> Bool
    func canDeleteItem(at indexPath: IndexPath) -> Bool

    func moveItem(at source: IndexPath, to destination: IndexPath)
    func moveSection(at source: Int, to destination: Int)

    func insertItem(_ item: ViewModel, at indexPath: IndexPath)
    func insertItems(_ items: [ViewModel], at indexPath: IndexPath)

    func insertSection(_ section: Section, at index: Int)
    func insertSections(_ sections: [Section], at index: Int)

    @discardableResult
    func deleteSection(at index: Int) -> Section?

    @discardableResult
    func deleteItem(at indexPath: IndexPath) -> ViewModel?

    func elementSize(at indexPath: IndexPath) -> ElementSize?
    func sectionProperties(at index: Int) -> Size.SectionProperties
}

public extension ListViewModel {

    func canMoveItem(at indexPath: IndexPath) -> Bool { false }

    func canDeleteItem(at indexPath: IndexPath) -> Bool { false }

    func insertItem(_ item: ViewModel, at indexPath: IndexPath) {
        guard let sectionIndex = indexPath.section,
              let itemIndex = indexPath.item,
              sectionIndex >= 0,
              sectionIndex < sections.count else { return }

        var section = self.sections[sectionIndex]
        section.insert(item, at: itemIndex)
        self.sections[sectionIndex] = section
    }
    func insertItems(_ items: [ViewModel], at indexPath: IndexPath) {
        guard let sectionIndex = indexPath.section,
              let itemIndex = indexPath.item,
              sectionIndex >= 0,
              sectionIndex < sections.count else { return }

        var section = self.sections[sectionIndex]
        section.insert(items, at: itemIndex)
        self.sections[sectionIndex] = section
    }

    func insertSection(_ section: Section, at index: Int) {
        if index < 0 {
            self.sections = [section] + self.sections
        } else if index >= self.sections.count {
            self.sections += [section]
        } else {
            self.sections.insert(section, at: index)
        }
    }
    func insertSections(_ sections: [Section], at index: Int) {
        if index < 0 {
            self.sections = sections + self.sections
        } else if index >= self.sections.count {
            self.sections += sections
        } else {
            self.sections.insert(contentsOf: sections, at: index)
        }
    }

    func moveItem(at source: IndexPath, to destination: IndexPath) {
        guard let sourceSectionIndex = source.section,
              let destinationSectionIndex = destination.section,
              let sourceItem = source.item,
              let destinationItem = destination.item else {
            return
        }
        // Use a temporary sections variable void triggering two updates by settings two different sections directly on self
        var sections = self.sections
        if sourceSectionIndex == destinationSectionIndex {
            sections[sourceSectionIndex].move(from: sourceItem, to: destinationItem)
        } else {
            var sourceSection = sections[sourceSectionIndex]
            var destinationSection = sections[destinationSectionIndex]
            if let item = sourceSection.remove(at: sourceItem) {
                destinationSection.insert(item, at: destinationItem)
            }

            sections[sourceSectionIndex] = sourceSection
            sections[destinationSectionIndex] = destinationSection
        }
        self.sections = sections
    }

    func moveSection(at source: Int, to destination: Int) {
        guard source >= 0,
              destination >= 0,
              source < sections.count,
              destination < sections.count
        else { return }

        var sections = self.sections
        sections.rearrange(from: source, to: destination)
        self.sections = sections
    }

    @discardableResult
    func deleteSection(at index: Int) -> Section? {
        guard self.sections.count > index, index >= 0 else {
            return nil
        }
        return self.sections.remove(at: index)
    }

    @discardableResult
    func deleteItem(at indexPath: IndexPath) -> ViewModel? {

        guard let sectionIndex = indexPath.section,
              let item = indexPath.item else { return nil }

        var section = self.sections[sectionIndex]
        let viewModel = section.remove(at: item)
        self.sections[sectionIndex] = section
        return viewModel
    }

    func elementSize(at indexPath: IndexPath) -> ElementSize? {
        (self[indexPath] as? WithElementSize)?.elementSize
    }

    func sectionProperties(at _: Int) -> Size.SectionProperties {
        .zero
    }

    /// Easily retrieves an item through its index path. If index path is out of bounds, `nil` is returned.
    subscript(index: IndexPath) -> ViewModel? {
        guard let section = index.section,
              let item = index.item,
            index.count == 2,
                sections.count > section,
                sections[section].items.count > item
                else { return nil }
            return sections[section].items[item]
    }

}

private extension IndexPath {
    var section: Int? {
        guard count == 2 else { return nil }
        return first
    }
    var item: Int? {
        guard count == 2 else { return nil }
        return last
    }
}
