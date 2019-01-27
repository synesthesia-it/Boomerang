//
//  CollectionViewSpec.swift
//  BoomerangTests
//
//  Created by Stefano Mondino on 20/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Quick
import Nimble
import RxSwift
@testable import Boomerang

extension String: ReusableListIdentifier {
    public var name: String { return self }
    public var className: AnyClass? {
        if self.shouldBeEmbedded {
            return nil
        } else {
        return TestCollectionViewCell.self
        }
    }
    public var shouldBeEmbedded: Bool { return self.contains("Cell") == false }
}

class CollectionViewSpec: QuickSpec {
    
    struct TestListViewModel: ListViewModel {
        typealias DataType = [String]
        var dataHolder: DataHolder = DataHolder()
        init() {
            dataHolder = DataHolder(data: group(.just((0..<5).map {"\($0)"})))
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
        describe("a Collection view") {
            context("When loaded with simple viewModel and not embeddable items") {
                
                class ViewController: UIViewController {
                    override func loadView() {
                        super.loadView()
                        let layout = UICollectionViewFlowLayout()
                        layout.itemSize = CGSize(width: 50, height: 50)
                        //                    viewController = UICollectionViewController(collectionViewLayout: layout)
                        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 300, height: 300), collectionViewLayout: layout)
                        self.view = collectionView
                    }
                }
                var viewModel = TestListViewModel()
                var viewController = ViewController(nibName: nil, bundle: nil)
                
                var collectionView: UICollectionView {
                    return viewController.view as! UICollectionView
                }
                beforeEach {
                    
                   viewController = ViewController(nibName: nil, bundle: nil)
                    let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
                    window.rootViewController = viewController
                    window.isHidden = false
                    viewModel = TestListViewModel()
                    collectionView.boomerang.configure(with: viewModel)
                    viewModel.delayedLoad()
                }
                
                
                it ("should display cells" ) {
                    expect(collectionView.dataSource).notTo(beNil())
                    expect(collectionView.frame.size.width) != 0
                    expect(collectionView.frame.size.height) != 0
                    expect(collectionView.numberOfSections).toEventually(be(1))
                    expect(collectionView.numberOfItems(inSection: 0)).toEventually(be(5))
                    var optionalCell: UICollectionViewCell?
                    
                    expect { () -> UICollectionViewCell? in
                        optionalCell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? TestCollectionViewCell
                        return optionalCell
                    }.toEventuallyNot(beNil())
                    expect(collectionView.numberOfItems(inSection: 0)) == 5
                    guard let cell = optionalCell as? TestCollectionViewCell  else { return }
                    expect(cell.viewModel).notTo(beNil())
                    expect(cell.backgroundColor) == UIColor.green
                    
                }
                
                it ("should allow insertions") {
                     let index = IndexPath(item: 5, section: 0)
                    var optionalCell: UICollectionViewCell?
                    
                    expect { () -> UICollectionViewCell? in
                        optionalCell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? TestCollectionViewCell
                        return optionalCell
                        }.toEventuallyNot(beNil())
                    waitUntil(timeout: 1) { done in
                       
                        viewModel.dataHolder.insert(["E"], at: index)
                        viewModel.dataHolder.insert(["F"], at:  IndexPath(item: 6, section: 0))
                        done()
                    }
                   
                    waitUntil(timeout: 1, action: { $0()})
//                     var optionalCell: UICollectionViewCell?
                    expect(collectionView.dataSource).notTo(beNil())
                     expect(collectionView.numberOfSections).toEventually(be(1))
                    expect { viewModel.dataHolder.modelGroup.models as? [String] } ==  ["0","1","2","3","4","E", "F"]
                    expect(collectionView.numberOfItems(inSection: 0)) == 7
                    expect { () -> UICollectionViewCell? in
                        optionalCell = collectionView.cellForItem(at: index) as? TestCollectionViewCell
                        return optionalCell
                        }.toEventuallyNot(beNil())
                }
                
                it ("should allow deletions") {
                    let index = IndexPath(item:0, section: 0)
                    var optionalCell: UICollectionViewCell?
                    
                    expect { () -> UICollectionViewCell? in
                        optionalCell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? TestCollectionViewCell
                        return optionalCell
                        }.toEventuallyNot(beNil())
                    waitUntil(timeout: 1) { done in
                        
                        viewModel.dataHolder.delete(at: [index])
                        done()
                    }
                    
                    waitUntil(timeout: 1, action: { $0()})
                    //                     var optionalCell: UICollectionViewCell?
                    expect(collectionView.dataSource).notTo(beNil())
                    expect(collectionView.numberOfSections).toEventually(be(1))
                    expect { viewModel.dataHolder.modelGroup.models as? [String] } ==  ["1","2","3","4"]
                    
                    expect { (viewModel.mainViewModel(at: index) as? TestItemViewModel)?.title } == "1"
                    expect(collectionView.numberOfItems(inSection: 0)) == 4
                    
                    waitUntil(timeout: 1) { done in
                        (0..<4).forEach {_ in
                            viewModel.dataHolder.delete(at: [index])
                        }
                        done()
                    }
                    expect(collectionView.numberOfItems(inSection: 0)) == 0
                    
                }
                it ("should not crash when too many delete are requested") {
                    let index = IndexPath(item:0, section: 0)
                    waitUntil(timeout: 1) { done in
                        (0..<5).forEach {_ in
                            viewModel.dataHolder.delete(at: [index])
                        }
                        done()
                    }
                    expect(collectionView.numberOfItems(inSection: 0)) == 0
                }
            }
        }
    }
}
