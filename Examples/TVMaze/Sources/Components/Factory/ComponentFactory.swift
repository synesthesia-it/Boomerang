//
//  CellFactory.swift
//  TVMaze
//
//  Created by Andrea De vito on 15/10/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Boomerang

enum ComponentIdentifier: String, LayoutIdentifier {
    var identifierString: String {self.rawValue}

    case show
    case scheduleShow
    case showInfo
    case episode
    case search
    case cast
    case actor
    case season
    case title
    case summary
    case subTitle
    case detail
    case credits
    case carousel
}

protocol ComponentFactory: CollectionViewCellFactory {

}
class SomeFactoryImplementation: ComponentFactory {
    var defaultCellIdentifier: String = "default"

    func cellClass(from itemIdentifier: Boomerang.LayoutIdentifier?) -> UICollectionViewCell.Type {
        ContentCollectionViewCell.self
    }

    func configureCell(_ cell: UICollectionReusableView, with viewModel: Boomerang.ViewModel) {
        guard let cell = cell as? ContentCollectionViewCell else { return }
        if cell.internalView == nil {
            cell.internalView = view(from: viewModel.layoutIdentifier)
        }
        cell.configure(with: viewModel)
    }

    func view(from itemIdentifier: LayoutIdentifier) -> UIView? {
        UINib(nibName: name(from: itemIdentifier), bundle: nil).instantiate(withOwner: nil, options: nil).first as? UIView
    }

    func name(from itemIdentifier: LayoutIdentifier) -> String {
        itemIdentifier.identifierString.prefix(1).uppercased() + itemIdentifier.identifierString.dropFirst() + "View"
    }

}
class ComponentFactoryImplementation: ComponentFactory {
    var defaultCellIdentifier: String = "default"

    func cellClass(from itemIdentifier: LayoutIdentifier?) -> UICollectionViewCell.Type {
        ContentCollectionViewCell.self
    }

    func configureCell(_ cell: UICollectionReusableView, with viewModel: ViewModel) {
        guard let cell = cell as? ContentCollectionViewCell else { return }
        if cell.internalView == nil {
            cell.internalView = view(from: viewModel.layoutIdentifier)
        }
        cell.configure(with: viewModel)
    }

    func view(from itemIdentifier: LayoutIdentifier) -> UIView? {
        UINib(nibName: name(from: itemIdentifier), bundle: nil).instantiate(withOwner: nil, options: nil).first as? UIView
    }

    func name(from itemIdentifier: LayoutIdentifier) -> String {
        itemIdentifier.identifierString.prefix(1).uppercased() + itemIdentifier.identifierString.dropFirst() + "View"
    }

    init() {}

}

enum SceneIdentifier: String, LayoutIdentifier {
    var identifierString: String {self.rawValue}

    case schedule
}
