//
//  AutomaticSizeCalculator.swift
//  Boomerang
//
//  Created by Stefano Mondino on 13/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//
#if os(iOS) || os(tvOS)
import UIKit

open class BaseTableViewHeightCalculator: TableViewHeightCalculator {

    public let viewModel: ListViewModel
    public let factory: TableViewCellFactory
    public let defaultHeight: CGFloat

    var cellCache: [String: UIView] = [:]

    public init(
        viewModel: ListViewModel,
        factory: TableViewCellFactory,
        defaultHeight: CGFloat) {
        self.viewModel = viewModel
        self.factory = factory
        self.defaultHeight = defaultHeight
    }

    open func autoHeightForItem(at indexPath: IndexPath,
                                in tableView: UITableView,
                                type: String? = nil) -> CGFloat {
        guard let cell = placeholderCell(at: indexPath,
                                         in: tableView,
                                         for: type) else {
            return .zero
        }
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return cell
            .systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            .height
    }

    open func viewModel(at indexPath: IndexPath, for type: String?) -> ViewModel? {
        let list = self.viewModel
        guard let type = type else { return list[indexPath] }

        return list.sections[indexPath.section]
            .supplementaryItem(atIndex: indexPath.item,
                  forKind: type.toSectionKind())

    }

    open func placeholderCell(at indexPath: IndexPath,
                               in tableView: UITableView,
                               for type: String?) -> UIView? {

        guard let viewModel = self.viewModel(at: indexPath, for: type)
            else {
                return nil
        }
        let identifier = viewModel.layoutIdentifier
        guard let cell: UIView = cellCache[identifier.identifierString] ?? factory.view(from: identifier)
            else { return nil }

        let content = cell// .boomerang.contentView
        content.translatesAutoresizingMaskIntoConstraints = false

        var constraint = content.constraints.filter {
            ($0.firstItem as? UIView) == content &&
                $0.firstAttribute == .width &&
                $0.secondItem == nil &&
                $0.secondAttribute == .notAnAttribute
        }.first
        if constraint == nil {
            let newConstraint = NSLayoutConstraint(item: content,
                                                   attribute: .width,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .notAnAttribute,
                                                   multiplier: 1.0,
                                                   constant: tableView.bounds.width)
            content.addConstraint(newConstraint)
            constraint = newConstraint
        } else {
            constraint?.constant = tableView.bounds.width
        }

        cell.isPlaceholderForAutosize = true

        self.cellCache[identifier.identifierString] = cell
        (cell as? WithViewModel)?.configure(with: viewModel)
        return cell
    }
    public func heightForItem(at indexPath: IndexPath,
                              in tableView: UITableView,
                              type: String?) -> CGFloat {
        guard let _ = self.viewModel(at: indexPath, for: type) else { return 0 }
        return defaultHeight
    }
}
#endif
