//
//  TestItemViewModel.swift
//  Boomerang
//
//  Created by Stefano Mondino on 13/11/16.
//
//

import Foundation
import Boomerang

extension String : ModelType {
    public var title: String? {return self}
}

final class TestItemViewModel: ItemViewModelType {
    
    
    public var model: ItemViewModelType.Model = ""
    var title:String { return self.model.title ?? "" }
    var customTitle:String?
    var itemIdentifier: ListIdentifier = "TestCollectionViewCell"
    
    convenience init(model: Item) {
        self.init(model:model as ItemViewModelType.Model)
        self.customTitle = model.string
    }
}
