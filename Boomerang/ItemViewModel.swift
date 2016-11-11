//
//  ItemViewModel.swift
//  Boomerang
//
//  Created by Stefano Mondino on 10/11/16.
//
//

import Foundation

public protocol ItemViewModelType : ViewModelType {
    typealias Model = ModelType
    var itemIdentifier:ListIdentifier {get set}
    var model:Model {get set}
    init(model:Model)
}

public extension ItemViewModelType {
    
    public init(model:ItemViewModelType.Model) {
        self.init()
        self.model = model
    }
}
