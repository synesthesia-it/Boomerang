//
//  ViewModel+Identifiable.swift
//  Boomerang
//
//  Created by Stefano Mondino on 06/08/18.
//

import Foundation
/**
    Default identifier that should never be used.
 It's a fallback case for UI components that do not support optionals  (ex: dequeue in collectionViews always expect to return something).
 */
public let defaultListIdentifier = "default_list_identifier"

/**
    Generic protocol to identify a view Model in a list
 */
public protocol ListIdentifier {
    /// A string name
    var name: String { get }
    /// In TableViews and CollectionViews, setting this value to true will have Boomerang to create custom default cells and embed provided xibs into them. This allow developers to decouple the itemView from its container (ex: the same view can be used as is in a collectionViews AND in a tableViews.
    /// Defaults to false
    var isEmbeddable: Bool { get }
}

extension ListIdentifier {
    /// Default value is false
    public var isEmbeddable: Bool { return false }
}

extension String: ListIdentifier {
    /// Default value is the string itself
    public var name: String {
        return self
    }
}
/**
 A view model that has an itemIdentifier
 */
public protocol ViewModelTypeIdentifiable: ViewModelType {
    /// Item identifier for the view model. Useful in lists.
    var itemIdentifier: ListIdentifier { get }
}
