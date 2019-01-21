//
//  ItemViewModelType.swift
//  Boomerang
//
//  Created by Stefano Mondino on 19/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public protocol ItemViewModelType: ViewModelType {
    var model: ModelType? { get }
}
extension ItemViewModelType {
    public var model: ModelType? { return nil }
    
    public func unwrappedModel<Model: ModelType>() -> Model? {
        return model as? Model
    }
}

public protocol Identifier {
    var name: String { get }
}
public protocol ReusableListIdentifier: Identifier {
    var shouldBeEmbedded: Bool { get }
    var className: AnyClass? { get }
}
public protocol IdentifiableViewModelType: ViewModelType {
    var identifier: Identifier { get }
}

public protocol IdentifiableItemViewModelType: IdentifiableViewModelType, ItemViewModelType {}
