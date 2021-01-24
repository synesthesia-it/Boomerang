//
//  CollectionViewCellFactory.swift
//  Demo
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
import Boomerang
import Boomerang

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
        ContentTableViewCell.self
    }
    func headerFooterCellClass(from itemIdentifier: LayoutIdentifier?) -> UITableViewHeaderFooterView.Type {
        ContentTableHeaderFooterViewCell.self
    }
    func configureCell(_ cell: UITableViewCell, with viewModel: ViewModel) {
        guard let cell = cell as? ContentTableViewCell else { return }
        if cell.internalView == nil {
            cell.internalView = viewFactory.view(from: viewModel.layoutIdentifier)
        }
        cell.configure(with: viewModel)

    }
    func configureCell(_ cell: UITableViewHeaderFooterView, with viewModel: ViewModel) {
        guard let cell = cell as? ContentTableHeaderFooterViewCell else { return }
        if cell.internalView == nil {
            cell.internalView = viewFactory.view(from: viewModel.layoutIdentifier)
        }
        cell.configure(with: viewModel)

    }
}
