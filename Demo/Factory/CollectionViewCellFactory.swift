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

class DefaultCollectionViewCellFactory: CollectionViewCellFactory {

    private var viewFactory: ViewFactory
    
    init(viewFactory: ViewFactory = DefaultViewFactory()) {
        self.viewFactory = viewFactory
    }
    
    func view(from itemIdentifier: ItemIdentifier) -> UIView? {
        return viewFactory.view(from: itemIdentifier)
    }
    
    func name(from itemIdentifier: ItemIdentifier) -> String {
        return itemIdentifier.description + "ItemView"
    }
    
    var defaultCellIdentifier: String {
        return "default"
    }
    
    func cellClass(from itemIdentifier: ItemIdentifier?) -> UICollectionViewCell.Type {
        return ContentCollectionViewCell.self
    }
    
    func configureCell(_ cell: UICollectionViewCell, with viewModel: ItemViewModel) {
        guard let cell = cell as? ContentCollectionViewCell else { return }
        if cell.internalView == nil {
            cell.internalView = viewFactory.view(from: viewModel.itemIdentifier)
        }
        cell.configure(with: viewModel)
    }
}
