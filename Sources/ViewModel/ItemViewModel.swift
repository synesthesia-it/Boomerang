//
//  ItemViewModel.swift
//  Boomerang
//
//  Created by Stefano Mondino on 10/11/16.
//
//

import Foundation
/**
 A view model that is created from a Model and can be inserted in a list handled by a ListViewModelType.
 `ViewModelTypeIdentifiable` conformance allows supporting components (tableViews, collectionViews, ecc...) to automatically generate a cell/view and bind this view model to it.
 - Note: Exceptionally, `ItemViewModelType` conforms to `ModelType`. This can be misleading, but has the enormous advantage that allows a developer to instantly embed in a `ListDataHolder` an array of pre-baked item view models that shares the same underlying model.
    For example, a detail page for a product is usually a list of graphical components that shows part of the same model. In those cases, the product model is split across many itemViewModels (with proper logic, whether to include some of them or not according to product status and properties) and directly loaded into a ModelStructure.
 */
public protocol ItemViewModelType: ViewModelTypeIdentifiable, ModelType {
    typealias Model = ModelType
    ///A title describing underlying model. Useful for generic identification in simple lists or pickers.
    var itemTitle: String? { get }
    /// The underlying model
    var model: Model { get }
}

public extension ItemViewModelType {
    /// Defaults to an empty string
    var itemTitle: String? {return ""}
}
