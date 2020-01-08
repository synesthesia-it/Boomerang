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
 
 The main use case scenario of a ListViewModel is for complex sections representing lists of components, either homogenous lists like a product list, or heterogeneous sections like a product detail.
    
 Each viewModel in the list is usually converted into a view by some other list-type view component (like table and collection views in UIKit).
 
 To populate a list viewModel, usually
 
 1. some user action triggers the `reload()` method, starting data retrieval from the Model layer (network calls, database fetch, etc...)
 2. data is eventually ready and structured into a single or multiple entities. According to app's business logic, these entities must be converted into an array of `Section` objects, each one containing one or many `ViewModel` by setting the `sections` variable
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
    ///The array of available sections
    var sections: [Section] { get }
    
    ///A closure that should be set from a View component and called each time a Section update is available
    var onUpdate: () -> Void { get set }
    
    ///Triggers data reload
    func reload()
    
    ///Should be called by external views/scenes to trigger some action related to a single element in a list.
    func selectItem(at indexPath: IndexPath)
}

public extension ListViewModel {
    
    ///Easily retrieves an item through its index path. If index path is out of bounds, `nil` is returned.
    subscript(index: IndexPath) -> ViewModel? {
        get {
            guard index.count == 2,
                sections.count > index.section,
                sections[index.section].items.count > index.item
                else { return nil }
            return sections[index.section].items[index.item]
        }
    }
}
