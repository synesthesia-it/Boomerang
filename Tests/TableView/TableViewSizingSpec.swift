//
//  TableViewSizingSpec.swift
//  BoomerangTests
//
//  Created by Alberto Bo on 12/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//


import Foundation
import Quick
import Nimble
import UIKit
import RxSwift
@testable import Boomerang

class TableViewSizingSpec: QuickSpec {
    override func spec() {
        
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
        var viewModel = TestListViewModel()
        var viewController = ViewController(nibName: nil, bundle: nil)
        let tableWidth: CGFloat = 400.0
        let tableHeight: CGFloat = 500.0
        let spacing:CGFloat = 10
        var tableView: UITableView {
            return viewController.view as! UITableView
        }
        describe("When using automatic sizing features, a table view") {
            context("when no flow delegate is specified, a table view") {
                
                beforeEach {
                    
                    viewController = ViewController(nibName: nil, bundle: nil)
                    let window = UIWindow(frame: CGRect(x: 0, y: 0, width: tableWidth, height: tableHeight))
                    window.rootViewController = viewController
                    window.isHidden = false
                    viewModel = TestListViewModel()
                    tableView.boomerang.configure(with: viewModel)
                    viewModel.delayedLoad()
                }
                
                it ("should properly calculate dimension for 1 item per line") {
                    expect(tableView.boomerang.calculateFixedDimension(at: IndexPath(item: 0, section: 0))) == tableWidth
                    
                }
            }
        }
    }
}
