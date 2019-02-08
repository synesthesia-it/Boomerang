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

class TableViewScheduleViewController: UIViewController, ViewModelCompatible, InteractionCompatible, UITableViewDelegate{

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.load()
    }
    
    func configure(with viewModel: TableViewScheduleViewModel) {
        tableView.delegate = self
        tableView.alwaysBounceVertical = true
        tableView.set(viewModel: viewModel)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.boomerang.automaticSizeForItem(at: indexPath).height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.interact(.selectItem(indexPath))
    }
    
}
