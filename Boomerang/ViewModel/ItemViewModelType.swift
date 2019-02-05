//
//  ItemViewModelType.swift
//  Boomerang
//
//  Created by Stefano Mondino on 19/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public protocol ItemViewModelType: IdentifiableViewModelType {
    var model: ModelType? { get }
}
extension ItemViewModelType {
    public var model: ModelType? { return nil }
    
    public func unwrappedModel<Model: ModelType>() -> Model? {
        return model as? Model
    }
}

public protocol IdentifiableViewModelType: ViewModelType, DataType {
    var identifier: Identifier { get }
}


