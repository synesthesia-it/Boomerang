//
//  TableViewCellFactory.swift
//  Demo
//
//  Created by Andrea Bellotto on 18/05/2020.
//  Copyright © 2020 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
import Boomerang
import UIKitBoomerang

class MainTableViewCellFactory: TableViewCellFactory {
    
    private var viewFactory: ViewFactory
    
    init(viewFactory: ViewFactory) {
        self.viewFactory = viewFactory
    }
    
    func view(from itemIdentifier: LayoutIdentifier) -> UIView? {
        return viewFactory.view(from: itemIdentifier)
    }
    
    func name(from itemIdentifier: LayoutIdentifier) -> String {
        return viewFactory.name(from: itemIdentifier)
    }
    
    var defaultCellIdentifier: String {
        return "default"
    }
    
    func cellClass(from itemIdentifier: LayoutIdentifier?) -> UITableViewCell.Type {
        return ContentTableViewCell.self
    }
    
    func configureCell(_ cell: UITableViewCell, with viewModel: ViewModel) {
        guard let cell = cell as? ContentTableViewCell else { return }
        if cell.internalView == nil {
            cell.internalView = viewFactory.view(from: viewModel.layoutIdentifier)
        }
        cell.configure(with: viewModel)
    }
}
