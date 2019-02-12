//
//  TableViewSpec.swift
//  BoomerangTests
//
//  Created by Alberto Bo on 12/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//


import Foundation
import Quick
import Nimble
import RxSwift
@testable import Boomerang


class TableViewSpec: QuickSpec {

    struct TestListViewModel: ListViewModel {
        typealias DataType = [String]
        var dataHolder: DataHolder = DataHolder()
        init() {
            dataHolder = DataHolder(data: group(.just((0..<5).map {"\($0)"})))
        }
        func convert(model: ModelType, at indexPath: IndexPath, for type: String?) -> IdentifiableViewModelType? {
            switch model {
            case let model as String : return TableTestItemViewModel(model: model)
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
        describe("a Table view") {
            context("When loaded with simple viewModel and not embeddable items") {

                class ViewController: UIViewController {
                    override func loadView() {
                        super.loadView()

                        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 50.0, height: UIScreen.main.bounds.height - 50.0))

                        self.view = tableView
                    }
                }
                var viewModel = TestListViewModel()
                var viewController = ViewController(nibName: nil, bundle: nil)

                var tableView:UITableView{
                    return viewController.view as! UITableView
                }
                beforeEach {

                    viewController = ViewController(nibName: nil, bundle: nil)
                    let window = UIWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
                    window.rootViewController = viewController
                    window.isHidden = false
                    viewModel = TestListViewModel()
                    tableView.boomerang.configure(with: viewModel)
                    viewModel.delayedLoad()
                }


                it ("should display cells" ) {
                    expect(tableView.dataSource).notTo(beNil())
                    expect(tableView.frame.size.width) != 0
                    expect(tableView.frame.size.height) != 0
                    expect(tableView.numberOfSections).toEventually(be(1))
                    expect(tableView.numberOfRows(inSection: 0)).toEventually(be(5))

                    var optionalCell: UITableViewCell?

                    expect { () -> UITableViewCell? in
                        optionalCell = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? TestTableViewCell
                        return optionalCell
                        }.toEventuallyNot(beNil())
                    expect(tableView.numberOfRows(inSection: 0)) == 5
                        
                    guard let cell = optionalCell as? TestTableViewCell  else { return }
                    expect(cell.viewModel).notTo(beNil())
                    expect(cell.backgroundColor) == UIColor.green

                }

                it ("should allow insertions") {
                    let index = IndexPath(item: 5, section: 0)
                    var optionalCell: TestTableViewCell?

                    expect { () -> TestTableViewCell? in
                        optionalCell = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? TestTableViewCell
                        return optionalCell
                        }.toEventuallyNot(beNil())
                    waitUntil(timeout: 1) { done in

                        viewModel.dataHolder.insert(["E"], at: index)
                        viewModel.dataHolder.insert(["F"], at:  IndexPath(item: 6, section: 0))
                        done()
                    }

                    waitUntil(timeout: 1, action: { $0()})
                    //                     var optionalCell: UICollectionViewCell?
                    expect(tableView.dataSource).notTo(beNil())
                    expect(tableView.numberOfSections).toEventually(be(1))
                    expect { viewModel.dataHolder.modelGroup.data as? [String] } ==  ["0","1","2","3","4","E", "F"]
                    expect(tableView.numberOfRows(inSection: 0)) == 7
                    expect { () -> UITableViewCell? in
                        optionalCell = tableView.cellForRow(at: index) as? TestTableViewCell
                        return optionalCell
                        }.toEventuallyNot(beNil())
                }

                it ("should allow deletions") {
                    let index = IndexPath(item:0, section: 0)
                    var optionalCell: UITableViewCell?

                    expect { () -> UITableViewCell? in
                        optionalCell = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? TestTableViewCell
                        return optionalCell
                        }.toEventuallyNot(beNil())
                    waitUntil(timeout: 1) { done in

                        viewModel.dataHolder.delete(at: [index])
                        done()
                    }

                    waitUntil(timeout: 1, action: { $0()})
                    //                     var optionalCell: UICollectionViewCell?
                    expect(tableView.dataSource).notTo(beNil())
                    expect(tableView.numberOfSections).toEventually(be(1))
                    expect { viewModel.dataHolder.modelGroup.data as? [String] } ==  ["1","2","3","4"]

                    expect { (viewModel.mainViewModel(at: index) as? TableTestItemViewModel)?.title } == "1"
                    expect(tableView.numberOfRows(inSection: 0)) == 4

                    waitUntil(timeout: 1) { done in
                        (0..<4).forEach {_ in
                            viewModel.dataHolder.delete(at: [index])
                        }
                        done()
                    }
                    expect(tableView.numberOfRows(inSection: 0)) == 0

                }
                it ("should not crash when too many delete are requested") {
                    let index = IndexPath(item:0, section: 0)
                    waitUntil(timeout: 1) { done in
                        (0..<5).forEach {_ in
                            viewModel.dataHolder.delete(at: [index])
                        }
                        done()
                    }
                    expect(tableView.numberOfRows(inSection: 0)) == 0
                }
            }
        }
    }
}
