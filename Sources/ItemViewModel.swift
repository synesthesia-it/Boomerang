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
    var itemTitle:String? {get}
    var model:Model {get set}
    init(model:Model)
}

public extension ItemViewModelType {
    var itemTitle:String? {return model.title}
    public init(model:ItemViewModelType.Model) {
        self.init()
        self.model = model
    }
}

public final class SimpleItemViewModel : ItemViewModelType {
    public var model:ModelType
    public var itemIdentifier: ListIdentifier = defaultListIdentifier
    public  init(model:ItemViewModelType.Model) {
        self.model = model
    }
}
