//
//  BoomerangTests.swift
//  BoomerangTests
//
//  Created by Stefano Mondino on 13/10/16.
//
//

import XCTest
import Nimble
import Quick
import ReactiveSwift
@testable import Boomerang

extension String : ModelType {
    public var title: String? {
        return self
    }
}


final class TestItemViewModel:ItemViewModelType {
    var itemIdentifier: ListIdentifier = "TestIdentifier"
    var model:ItemViewModelType.Model = ""
    var title:String? { return model.title}
    convenience init (model:String) {
        self.init(model: model as ItemViewModelType.Model)
    }
}



class ItemViewModelSpec: QuickSpec {
    override func spec() {
        describe("a ItemViewModelType ") {
            context("when initialized") {
                it("has everything you need to get started") {
                    let viewModel = TestItemViewModel(model: "TEST")
                    expect(viewModel.itemIdentifier.name).to(equal("TestIdentifier"))
                    expect(viewModel.model.title).to(equal("TEST"))
                }
            }
        }
    }
}


