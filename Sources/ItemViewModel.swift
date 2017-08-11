//
//  ItemViewModel.swift
//  Boomerang
//
//  Created by Stefano Mondino on 10/11/16.
//
//

import Foundation

public protocol ItemViewModelType : ViewModelTypeIdentifiable,  ModelType {
    typealias Model = ModelType
    var itemTitle:String? { get }
    var model:Model {get set}
    
}

public extension ItemViewModelType {
    var itemTitle:String? {return ""}
}
extension String : ModelType {
    public var title:String? {
    return self
    }
}
public final class SimpleItemViewModel : ItemViewModelType {
    public var model:ModelType
    public var itemIdentifier: ListIdentifier = defaultListIdentifier
    public init(model: Model) {
        self.model = model
    }
    convenience public init(model:ItemViewModelType.Model, itemIdentifier:ListIdentifier = defaultListIdentifier) {
        self.init(model: model)
        self.itemIdentifier = itemIdentifier
    }
}
