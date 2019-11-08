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

class MainCollectionViewCellFactory: CollectionViewCellFactory {

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

    func cellClass(from itemIdentifier: LayoutIdentifier?) -> UICollectionViewCell.Type {
        return ContentCollectionViewCell.self
    }

    func configureCell(_ cell: UICollectionReusableView, with viewModel: ViewModel) {
        guard let cell = cell as? ContentCollectionViewCell else { return }
        if cell.internalView == nil {
            cell.internalView = viewFactory.view(from: viewModel.layoutIdentifier)
        }
        cell.configure(with: viewModel)
    }
}
