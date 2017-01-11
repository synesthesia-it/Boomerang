//
//  ItemViewModel.swift
//  Boomerang
//
//  Created by Stefano Mondino on 10/11/16.
//
//

import Foundation

public protocol ItemViewModelType : ViewModelType, ModelType {
    typealias Model = ModelType
    var itemIdentifier:ListIdentifier {get set}
    var itemTitle:String? {get}
    var model:Model {get set}
    init(model:Model)
}

public extension ItemViewModelType {
    var itemTitle:String? {return model.title}
    var title:String? {return self.itemTitle}
    public init(model:ItemViewModelType.Model) {
        self.init()
        self.model = model
    }
}
extension String : ModelType {
    public var title:String? {
    return self
    }
}
public final class SimpleItemViewModel : ItemViewModelType {
    public var model:ModelType
    public var itemIdentifier: ListIdentifier = defaultListIdentifier
    public  init(model:ItemViewModelType.Model, itemIdentifier:ListIdentifier = defaultListIdentifier) {
        self.model = model
        self.itemIdentifier = itemIdentifier
    }
}
