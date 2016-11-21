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

class ModelStructureSpec: QuickSpec {
    override func spec() {
        describe("a ModelStructure ") {
            it("has everything you need to get started") {
                
                let s = ModelStructure([ModelType]())
                expect(s.models).to(haveCount(0))
                expect(s.children).to(beNil())
                
            }
            context ("when initialized with a single 'line'") {
                it ("should not have any child") {
                    let s = ModelStructure(["A","B","C"])
                    expect (s.children).to(beNil())
                    expect (s.models).to(haveCount(3))
                }
                it ("should properly return indexPaths") {
                    let s = ModelStructure(["A","B","C"])
                    
                    expect(s.indexPaths()).to(equal([IndexPath(indexes:[0]),IndexPath(indexes:[1]),IndexPath(indexes:[2])]))
                }
            }
            
            context ("when initialized multiline") {
                it ("should not have models") {
                    let s = ModelStructure(children: [
                        ModelStructure(["A"]),
                        ModelStructure(["B"]),
                        ModelStructure(["C"])
                        ])
                    expect (s.models).to(beNil())
                    expect(s.children).to(haveCount(3))
                    
                }
                it ("should should have titles") {
                    let s = ModelStructure(children: [
                        ModelStructure(["A"], sectionModel:"Title")
                        ])
                    expect (s.models).to(beNil())
                    expect(s.children).to(haveCount(1))
                    expect(s.children?.first?.sectionModel as? String).to(equal("Title"))
                }
                
                
                it ("should properly return indexPaths") {
                    let s1 = ModelStructure(children: [
                        ModelStructure(["A","D"]),
                        ModelStructure(["B"]),
                        ModelStructure(["C"])
                        ])
                    expect(s1.indexPaths()).to(equal([IndexPath(indexes:[0,0]),IndexPath(indexes:[0,1]),IndexPath(indexes:[1,0]),IndexPath(indexes:[2,0])]))
                    
                    let s2 = ModelStructure(children: [s1,s1])
                    expect(s2.indexPaths()).to(equal([IndexPath(indexes:[0,0,0]),IndexPath(indexes:[0,0,1]),IndexPath(indexes:[0,1,0]),IndexPath(indexes:[0,2,0]),
                                                      IndexPath(indexes:[1,0,0]), IndexPath(indexes:[1,0,1]),IndexPath(indexes:[1,1,0]),IndexPath(indexes:[1,2,0])]))
                }
                it ("should properly return all data as one-line array") {
                    let s1 = ModelStructure(children: [
                        ModelStructure(["A","D"]),
                        ModelStructure(["B"]),
                        ModelStructure(["C"])
                        ])
                    
                    expect (s1.allData() as? [String]).to(equal(["A","D","B","C"]))
                    
                    
                    let s2 = ModelStructure(children: [s1,s1])
                    expect(s2.allData() as? [String]).to(equal(["A","D","B","C","A","D","B","C"]))
                }
            }
            
//            context("when a dataProducer is provided") {
//                it("should properly transform models in viewModels upon reload") {
//                    let viewModel = TestListViewModel(dataProducer: SignalProducer(value: ModelStructure(["A","B","C"])))
//                    expect(viewModel.models.value.models).to(haveCount(0))
//                    viewModel.reload()
//                    expect(viewModel.resultsCount.value).to(equal(3))
//                    
//                    expect(viewModel.viewModels.value).to(haveCount(0))
//                    let ip = IndexPath(indexes: [0])
//                    expect(viewModel.viewModelAtIndex(ip)?.model.title).to(equal("A"))
//                    let matrixIP = IndexPath(indexes: [0,0])
//                    expect(viewModel.viewModelAtIndex(matrixIP)?.model.title).to(equal("A"))
//                }
//            }
//            context("when a dataProducer is meant to take time to provide results") {
//                it("should properly sync the isLoading property on the viewModel") {
//                    let viewModel = TestListViewModel(dataProducer: SignalProducer(value: ModelStructure(["A","B","C"])).delay(3.0, on:QueueScheduler.main))
//                    viewModel.reload()
//                    expect(viewModel.isLoading.value).toEventually(equal(true))
//                    expect(viewModel.isLoading.value).toEventually(equal(false), timeout: 4.0, pollInterval: 1.0, description: "Loading didn't complete")
//                }
//            }
            
        }
    }
}


