//
//  ViewModel.swift
//  Boomerang
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
/**
    The most simple kind of viewModel.
 */
public protocol ViewModel: WithPropertyAssignment {
   /**
    A unique identifier used to identify this view model in lists.
    
    A view model should always be uniquely identifiable inside a list of ViewModels,
     so that differences can be calculated automatically by some kind of frameworks like RxDataSources or SwiftUI.
    If this kind of information is not available, safely return `UUID()`
    */
    var uniqueIdentifier: UniqueIdentifier { get }

    /**
     An identifier used by the view layer to create proper layout object (view, view controller, etc)
     
     Since a view model is always coupled to a view object, this identifier is used
     to express information about layout without explicitly referencing the view object.
     */
    var layoutIdentifier: LayoutIdentifier { get }
}

/// An object identifying a layout type.
public protocol LayoutIdentifier {
    var identifierString: String { get }
}

/// A unique identier object.
public protocol UniqueIdentifier {
    var stringValue: String { get }
}

extension String: UniqueIdentifier {
    public var stringValue: String { return self }
}

extension UUID: UniqueIdentifier {
    public var stringValue: String { return self.uuidString }
}
extension Int: UniqueIdentifier {
    public var stringValue: String { return "\(self)" }
}

/// An object that can be bound to a viewModel
public protocol WithViewModel: AnyObject {
    func configure(with viewModel: ViewModel)
}
