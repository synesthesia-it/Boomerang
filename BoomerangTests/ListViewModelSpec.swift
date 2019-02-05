//
//  ListViewModelSpec.swift
//  BoomerangTests
//
//  Created by Stefano Mondino on 20/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Quick
import Nimble
import RxSwift
import RxBlocking

@testable import Boomerang

class ListViewModelSpec: QuickSpec {
    
    struct TestItemViewModel: ItemViewModelType {
        var model: ModelType? { return title }
        var date: Date = Date()
        var identifier: Identifier = ""
        var title: String
        init(model: String) {
            self.title = model
        }
    }
    
    struct TestListViewModel: ListViewModel {
        typealias DataType = [String]
        var dataHolder: DataHolder = DataHolder()
        init() {
            dataHolder = DataHolder(data: .empty())
        }
        init(observable: Observable<DataType>){
            self.dataHolder = DataHolder(data: self.group(observable))
        }
        func convert(model: ModelType, at indexPath: IndexPath, for type: String?) -> IdentifiableViewModelType? {
            switch model {
            case let model as String : return TestItemViewModel(model: model)
            default: return nil
            }
        }
        
        func group(_ observable: Observable<[String]>) -> Observable<DataGroup> {
            return observable.map {
                DataGroup($0)
            }
        }
    }
    
    override func spec() {
        describe("a ListViewModel") {
            var viewModel: TestListViewModel = TestListViewModel()
            beforeEach {
                viewModel = TestListViewModel(observable: Observable
                    .just(["A","B","C","D"])
                    .delaySubscription(0.5, scheduler: MainScheduler.instance))
            }
            context("with default values") {
                it ("should cache items") {
                    expect(viewModel.dataHolder.useCache) == true
                }
            }
            context("when item view model cache is on") {
                it("should reload and emit proper viewModels") {
                    viewModel.load()
                    var vm:TestItemViewModel?
                    expect{
                        vm = viewModel.mainViewModel(at: IndexPath(item: 0, section: 0)) as? TestItemViewModel
                        }
                        .toEventuallyNot(beNil())
                    guard let item = vm else { return }
                    expect(item.title) == "A"
                }
                it("should not create same view model when accessing it") {
                    viewModel.dataHolder.useCache = true
                    viewModel.load()
                    var vm1:TestItemViewModel?
                    var vm2:TestItemViewModel?
                    expect{
                        vm1 = viewModel.mainViewModel(at: IndexPath(item: 0, section: 0)) as? TestItemViewModel
                        vm2 = viewModel.mainViewModel(at: IndexPath(item: 0, section: 0)) as? TestItemViewModel
                        return vm1 != nil && vm2 != nil
                        }
                        .toEventually(beTrue())
                    
                    expect(vm1?.date) == vm2?.date
                    expect(vm1?.model).toNot(beNil())
                    expect {
                        let string: String? = vm1?.unwrappedModel()
                        return string
                        } == "A"
                }
            }
        }
    }
}
