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
    
    var dataHolder: ListDataHolderType = ListDataHolder.empty
    
    func itemViewModel(fromModel model: ModelType) -> ItemViewModelType? {
        return TestItemViewModel(model: model)
    }
    var listIdentifiers:[ListIdentifier] {
        return ["TestItem"]
    }
    

}

class ListDataHolderSpec: QuickSpec {
    override func spec() {
        describe("a ViewModelListType ") {
            it("has everything you need to get started") {
                
                let dataHolder = ListDataHolder(dataProducer : SignalProducer(value:ModelStructure.empty))
                expect(dataHolder.reloadAction).notTo(beNil())
//                expect(viewModel.models.value).to(be(ModelStructure.empty))
                expect(dataHolder.viewModels.value).to(haveCount(0))
                
            }
            
            context("when a dataProducer is provided") {
                it("should properly transform models in viewModels upon reload") {
                     let dataHolder = ListDataHolder (dataProducer: SignalProducer(value: ModelStructure(["A","B","C"])))
                    expect(dataHolder.models.value.models).to(haveCount(0))
                    dataHolder.reload()
                    expect(dataHolder.resultsCount.value).to(equal(3))
                    
                    expect(dataHolder.viewModels.value).to(haveCount(0))
//                    let ip = IndexPath(indexes: [0])
//                    expect(dataHolder.viewModelAtIndex(ip)?.model.title).to(equal("A"))
//                    let matrixIP = IndexPath(indexes: [0,0])
//                    expect(dataHolder.viewModelAtIndex(matrixIP)?.model.title).to(equal("A"))
                }
            }
            context("when a dataProducer is meant to take time to provide results") {
                it("should properly sync the isLoading property on the viewModel") {
                    let viewModel = TestListViewModel(dataProducer: SignalProducer(value: ModelStructure(["A","B","C"])).delay(3.0, on:QueueScheduler.main))
                    viewModel.reload()
                    //expect(viewModel.dataHolder.isLoading.value).toEventually(equal(true))
                    //expect(viewModel.dataHolder.isLoading.value).toEventually(equal(false), timeout: 4.0, pollInterval: 1.0, description: "Loading didn't complete")
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


