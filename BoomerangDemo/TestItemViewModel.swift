//
//  TestItemViewModel.swift
//  Boomerang
//
//  Created by Stefano Mondino on 13/11/16.
//
//

import Foundation
import Boomerang


enum TestIdentifier : ListIdentifier {
    case test
    
    var type: String? { return nil }
    var name: String { return "TestView" }
    var isEmbeddable: Bool { return true }
}

final class TestItemViewModel: ItemViewModelType {
    
    
    public var model: ItemViewModelType.Model = ""
    var title:String { return (self.model as? String)?.title ?? "" }
    var customTitle:String?
    var itemIdentifier: ListIdentifier = TestIdentifier.test//"TestTableViewCell"
    
     init(model: Item) {
        self.model = model
        self.customTitle = model.string
    }
    init(model: Section, type:String = "") {
        self.model = model
        self.customTitle = model.string
        self.itemIdentifier = HeaderIdentifier(name: "TestHeaderTableViewCell", type: type)
    }
}
