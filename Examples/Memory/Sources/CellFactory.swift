//
//  CellFactory.swift
//  GameOfFifteen_iOS
//
//  Created by Stefano Mondino on 05/12/21.
//

import Foundation
import Boomerang
import UIKit
class CellFactory: CollectionViewCellFactory {

    init() {}

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
        return identifier.prefix(1).uppercased() + identifier.dropFirst() + "View"
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
            cell.internalView = view(from: viewModel.layoutIdentifier)
        }
        cell.configure(with: viewModel)
    }
}
