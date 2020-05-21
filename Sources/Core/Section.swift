//
//  Section.swift
//  Boomerang
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
/** A basic object representing a group of ViewModel, usually created by a `ListViewModel`
 
 A `Section` is modelled following the most complex use case in UIKit common lists (`UICollectionView`)
 
 The most simple use case scenario is a list of `ViewModel` objects: when the section is delivered to the view component, each ViewModel will be associated to a single view/cell
 
 `Section` supports out of the box additional view models for headers and footers (for both `UITableView` and `UICollectionViews`) and supplementary views (`UICollectionView` specific).
 
 */
public struct Section {
    /** A basic object representing supplementary informations for a single `Section`
     
         Each Item in Section can have 0, 1 or more supplementary viewModel; each type of viewModel is identified through a `kind` string.
            
        Section' s headers and footers are usually supplementary informations of the first element
     */
    typealias KindMap = [String: ViewModel]
    public struct Supplementary {
        public static let header = "internal_header_type"
        public static let footer = "internal_footer_type"

        internal var items: [Int: KindMap] = [:]

        ///Set a view model to matching item and kind
        mutating public func set(_ viewModel: ViewModel, withKind kind: String, atIndex index: Int) {
            var kindMap = self.items[index] ?? [:]
            kindMap[kind] =  viewModel
            self.items[index] = kindMap
        }
        ///Set a view model as header.
        mutating public func set(header viewModel: ViewModel) {
            self.set(viewModel, withKind: Section.Supplementary.header, atIndex: 0)
        }
        ///Set a view model as footer.
        mutating public func set(footer viewModel: ViewModel) {
            self.set(viewModel, withKind: Section.Supplementary.footer, atIndex: 0)
        }
        ///Retrieve proper view model for given kind and index.
        public func item(atIndex index: Int, forKind kind: String) -> ViewModel? {
            return items[index]?[kind]
        }
    }

    ///Unique id representing the section.
    ///Uniqueness is required by differentiators algorithms to detect differences between sections
    public var id: String

    ///The `ViewModel` items contained inside the Section
    public var items: [ViewModel]

    ///The `Supplementary` object representing additional viewModels for each item
    public var supplementary: Supplementary

    ///Convenience helper to get the header view model from `Supplementary` object
    public var header: ViewModel? {
        return supplementary.item(atIndex: 0, forKind: Supplementary.header)
    }

    ///Convenience helper to get the footer view model from `Supplementary` object
    public var footer: ViewModel? {
        return supplementary.item(atIndex: 0, forKind: Supplementary.footer)
    }

    /**
    Create a new `Section` object from given items.
    
     - Parameter id: Id used to guarantee uniqueness of current section. Defaults to `""`
     
     - Parameter items: The section's `ViewModel` array
     
     - Parameter header: Optional header viewModel. Defaults to `nil`
     
     - Parameter footer: Optional footer viewModel. Defaults to `nil`
     
     - Parameter supplementary: Optional supplementary object. Defaults to `nil`
                
     */
    public init( id: String = "",
                 items: [ViewModel] = [],
                 header: ViewModel? = nil,
                 footer: ViewModel? = nil,
                 supplementary: Supplementary? = nil) {
        self.id = id
        self.items = items
        var supplementary = supplementary ?? Supplementary()
        if let header = header {
            supplementary.set(header: header)
        }
        if let footer = footer {
            supplementary.set(footer: footer)
        }
        self.supplementary = supplementary
    }

    public mutating func insert(_ item: ViewModel, at index: Int) {
        self.items.insert(item, at: index)
    }
    public mutating func insert(_ items: [ViewModel], at index: Int) {
        self.items.insert(contentsOf: items, at: index)
    }

    public mutating func move(from: Int, to: Int) {
        self.items.rearrange(from: from, to: to)
    }

    public mutating func remove(at index: Int) -> ViewModel? {
        guard items.count > index, index >= 0 else { return nil }
        return self.items.remove(at: index)
    }
}

internal extension Array {
    mutating func rearrange(from: Int, to: Int) {
        insert(remove(at: from), at: to)
    }
}
