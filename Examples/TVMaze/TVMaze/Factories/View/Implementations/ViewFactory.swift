//
//  ViewFactory.swift
//  TVMaze
//
//  Created by Stefano Mondino on 21/05/2020.
//  Copyright © 2020 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import UIKit
import UIKitBoomerang
typealias View = UIView

struct UIViewFactory: ViewFactory {
    func view(from itemIdentifier: LayoutIdentifier) -> UIView? {
        return nib(from: itemIdentifier)?
            .instantiate(withOwner: nil, options: nil)
            .first as? UIView
    }

    func nib(from itemIdentifier: LayoutIdentifier) -> UINib? {
        return UINib(nibName: name(from: itemIdentifier), bundle: nil)
    }

    func name(from itemIdentifier: LayoutIdentifier) -> String {
        let identifier = itemIdentifier.identifierString

        return identifier.prefix(1).uppercased() + identifier.dropFirst() + "ItemView"
    }
}

class UICollectionViewCellFactory: CollectionViewCellFactory {

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

