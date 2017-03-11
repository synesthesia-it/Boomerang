//
//  TestItemViewModel.swift
//  Boomerang
//
//  Created by Stefano Mondino on 13/11/16.
//
//

import Foundation
import Boomerang

final class TestItemViewModel: ItemViewModelType {
    
    
    public var model: ItemViewModelType.Model = ""
    var title:String { return (self.model as? String)?.title ?? "" }
    var customTitle:String?
    var itemIdentifier: ListIdentifier = "TestTableViewCell"
    
    convenience init(model: Item) {
        self.init(model:model as ItemViewModelType.Model)
        self.customTitle = model.string
    }
    convenience init(model: Section) {
        self.init(model:model as ItemViewModelType.Model)
        self.customTitle = model.string
        self.itemIdentifier = HeaderIdentifier(name: "TestHeaderTableViewCell", type: TableViewHeaderType.footer.identifier)
    }
}
