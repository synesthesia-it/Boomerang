//
//  ModelStructureSpec.swift
//  BoomerangTests
//
//  Created by Stefano Mondino on 19/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//


import Quick
import Nimble
import RxSwift
import RxBlocking

@testable import Boomerang



enum DataHolderError: Error {
    case error
    case error2
}

class DataHolderSpec: QuickSpec {
    override func spec() {
        describe("a 'DataHolder' object") {
            var dataHolder = DataHolder()
            context("when initialized with an array of simple model objects") {
                
                beforeEach {
                   dataHolder = DataHolder(data:
                    Observable.just(DataGroup(["A","B","C"])).delay(0.5, scheduler: MainScheduler.instance))
                    dataHolder.delayedStart()
                }
            
            it ("Should properly map every model") {
                expect(dataHolder[IndexPath(indexes: [0])]).toEventually(be("A"))
                let expectedGroup = (try? dataHolder.groups.take(1).toBlocking().last())
                expect(expectedGroup).notTo(beNil())
                guard let group = expectedGroup! else { return }
                expect(group.first as? String) == "A"
                expect(group.last as? String) == "C"
            }
            }
            
            context ("When an error occurs") {
                
                beforeEach {
                    dataHolder = DataHolder(data:
                        Observable<DataGroup>.error(DataHolderError.error)
                            .delaySubscription(0.5, scheduler: MainScheduler.instance)
                        )
                }
                
                it ("Should propagate error to proper observable") {
                    dataHolder.delayedStart()
                    expect(try! dataHolder.errors.take(1).toBlocking().last() as? DataHolderError) == DataHolderError.error
                }
                it ("Should cancel execution") {
                    dataHolder.delayedStart()
                    dataHolder.cancel()
                    expect(try! dataHolder.groups.take(1).toBlocking().last()?.count) == 0
                }
            }
        }
    }
}
