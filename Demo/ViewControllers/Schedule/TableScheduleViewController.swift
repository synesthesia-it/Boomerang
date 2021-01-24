//
//  ViewController.swift
//  NewArch
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit
import RxBoomerang
import RxDataSources
import RxSwift

class TableScheduleViewController: UIViewController, WithViewModel {

    typealias ScheduleViewModel = ListViewModel & NavigationViewModel

    @IBOutlet weak var tableView: UITableView!

    var viewModel: ListViewModel & NavigationViewModel

    var tableViewDataSource: TableViewDataSource? {
        didSet {
            self.tableView.dataSource = tableViewDataSource
            self.tableView.reloadData()
        }
    }

    var tableViewDelegate: TableViewDelegate? {
        didSet {
            self.tableView.delegate = tableViewDelegate
            self.tableView.reloadData()
        }
    }

    var disposeBag = DisposeBag()
    private let tableViewCellFactory: TableViewCellFactory

    init(nibName nibNameOrNil: String?,
         bundle nibBundleOrNil: Bundle? = nil,
         viewModel: ListViewModel & NavigationViewModel,
         tableViewCellFactory: TableViewCellFactory) {
        self.viewModel = viewModel
        self.tableViewCellFactory = tableViewCellFactory
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: ViewModel) {
        guard let viewModel = viewModel as? ScheduleViewModel else { return }
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //        guard let viewModel = viewModel else { return }
        let viewModel = self.viewModel
        tableView.estimatedRowHeight = 100
        let tableViewDataSource = TableViewDataSource(viewModel: viewModel,
                                                      factory: tableViewCellFactory)

        let sizeCalculator = DynamicHeightCalculator(viewModel: viewModel,
                                                           factory: tableViewCellFactory)

        let tableViewDelegate = TableViewDelegate(heightCalculator: sizeCalculator, dataSource: tableViewDataSource)
            .withSelect { viewModel.selectItem(at: $0) }

        if let viewModel = viewModel as? RxListViewModel {
            tableView.rx
                .animated(by: viewModel, dataSource: tableViewDataSource)
                .disposed(by: disposeBag)
        } else {
            self.tableViewDataSource = tableViewDataSource
            viewModel.onUpdate = { [weak self] in
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }

        if let viewModel = viewModel as? RxNavigationViewModel {
            viewModel.routes
                .bind(to: self.rx.routes())
                .disposed(by: disposeBag)
//            viewModel.routes
//                .observeOn(MainScheduler.instance)
//                .bind { [weak self] route in
//                    route.execute(from: self)
//            }.disposed(by: disposeBag)
        } else {
            viewModel.onNavigation = { [weak self] route in
                route.execute(from: self)
            }
        }

        self.tableViewDelegate = tableViewDelegate

        viewModel.reload()

    }

}
