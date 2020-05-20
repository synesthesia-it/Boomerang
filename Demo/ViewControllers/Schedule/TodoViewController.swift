//
//  UIKitTableViewController.swift
//  Demo
//
//  Created by Andrea Bellotto on 18/05/2020.
//  Copyright © 2020 Synesthesia. All rights reserved.
//

import UIKit
import UIKitBoomerang


class TodoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    typealias TodoViewModel = ListViewModel & NavigationViewModel
    var viewModel: TodoViewModel
    
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
    
    private let tableViewCellFactory: TableViewCellFactory

    init(nibName nibNameOrNil: String?,
         bundle nibBundleOrNil: Bundle? = nil,
         viewModel: TodoViewModel,
         tableViewCellFactory: TableViewCellFactory) {
        self.viewModel = viewModel
        self.tableViewCellFactory = tableViewCellFactory
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewModel = self.viewModel
        let tableViewDataSource = TableViewDataSource(viewModel: viewModel,
                                                                factory: tableViewCellFactory)
        
        let tableViewDelegate = TableViewDelegate(rowHeight: 100)
            .withSelect {
                viewModel.selectItem(at: $0)
                self.tableView.deselectRow(at: $0, animated: true)
        }

        
        self.tableViewDataSource = tableViewDataSource
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        self.tableViewDelegate = tableViewDelegate
        
        viewModel.reload()


    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
