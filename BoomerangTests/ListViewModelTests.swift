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

final class TestListViewModel:ListViewModelType {
    
    var reloadAction: Action<ResultRangeType?, ModelStructure, NSError> = Action {_ in return SignalProducer(value:ModelStructure.empty)}
    var models:MutableProperty<ModelStructure> = MutableProperty(ModelStructure.empty)
    var viewModels:MutableProperty = MutableProperty([IndexPath:ItemViewModelType]())
    var isLoading:MutableProperty<Bool> = MutableProperty(false)
    var resultsCount:MutableProperty<Int> = MutableProperty(0)
    var newDataAvailable:MutableProperty<ResultRangeType?> = MutableProperty(nil)
    init() {}
    
    func itemViewModel(_ model: ModelType) -> ItemViewModelType? {
        return TestItemViewModel(model: model)
    }
    func listIdentifiers() -> [ListIdentifier] {
        return ["TestItem"]
    }
    
    func select(selection: SelectionType) -> ViewModelType {
        return TestListViewModel()
    }
}

class ViewModelListSpec: QuickSpec {
    override func spec() {
        describe("a ViewModelListType ") {
            it("has everything you need to get started") {
                
                let viewModel = TestListViewModel(dataProducer : SignalProducer(value:nil))
                expect(viewModel.reloadAction).notTo(beNil())
//                expect(viewModel.models.value).to(be(ModelStructure.empty))
                expect(viewModel.viewModels.value).to(haveCount(0))
                
            }
            
            context("when a dataProducer is provided") {
                it("should properly transform models in viewModels upon reload") {
                    let viewModel = TestListViewModel(dataProducer: SignalProducer(value: ModelStructure(["A","B","C"])))
                    expect(viewModel.models.value.models).to(haveCount(0))
                    viewModel.reload()
                    expect(viewModel.resultsCount.value).to(equal(3))
                    
                    expect(viewModel.viewModels.value).to(haveCount(0))
                    let ip = IndexPath(indexes: [0])
                    expect(viewModel.viewModelAtIndex(ip)?.model.title).to(equal("A"))
                    let matrixIP = IndexPath(indexes: [0,0])
                    expect(viewModel.viewModelAtIndex(matrixIP)?.model.title).to(equal("A"))
                }
            }
            context("when a dataProducer is meant to take time to provide results") {
                it("should properly sync the isLoading property on the viewModel") {
                    let viewModel = TestListViewModel(dataProducer: SignalProducer(value: ModelStructure(["A","B","C"])).delay(3.0, on:QueueScheduler.main))
                    viewModel.reload()
                    expect(viewModel.isLoading.value).toEventually(equal(true))
                    expect(viewModel.isLoading.value).toEventually(equal(false), timeout: 4.0, pollInterval: 1.0, description: "Loading didn't complete")
                }
            }
            
            //            context("if it doesn't have what you're looking for") {
            //                it("needs to be updated") {
            //                    let you = You(awesome: true)
            //                    expect{you.submittedAnIssue}.toEventually(beTruthy())
            //                }
            //            }
        }
    }
}


