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

@testable import Boomerang


extension String : ModelType {}

final class TestItemViewModel:ItemViewModelType {
    var itemIdentifier: ListIdentifier = "TestIdentifier"
    var model:ItemViewModelType.Model = ""
    init (model:String) {
        self.model = model
    }
}



class ItemViewModelSpec: QuickSpec {
    override func spec() {
        describe("a ItemViewModelType ") {
            context("when initialized") {
                it("has everything you need to get started") {
                    let viewModel = TestItemViewModel(model: "TEST")
                    expect(viewModel.itemIdentifier.name).to(equal("TestIdentifier"))
                }
            }
        }
    }
}


