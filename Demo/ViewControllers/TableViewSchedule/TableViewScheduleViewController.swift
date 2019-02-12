//
//  TableViewScheduleController.swift
//  Demo
//
//  Created by Alberto Bo on 08/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//


import Foundation
import UIKit
import RxSwift
import RxCocoa
import Boomerang

class TableViewScheduleViewController: UIViewController, ViewModelCompatible, InteractionCompatible{

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.load()
    }
    
    func configure(with viewModel: TableViewScheduleViewModel) {
        tableView.alwaysBounceVertical = true
        let delegate = TableViewDelegate()
            .with(size: { table, index, type in
                table.boomerang.automaticSizeForItem(at: index, type: type)
            })
        
        tableView.boomerang.configure(with: viewModel, delegate: delegate)


    }
    
}
