//
//  AutomaticSizeCalculator.swift
//  Boomerang
//
//  Created by Stefano Mondino on 13/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//
#if os(iOS) || os(tvOS)
import UIKit

open class BaseCollectionViewSizeCalculator: CollectionViewSizeCalculator {

    public struct LockingSize {
        public var direction: Direction
        public var value: CGFloat

        public init(direction: Direction, value: CGFloat) {
            self.direction = direction
            self.value = value
        }

        public var type: NSLayoutConstraint.Attribute {
            switch direction {
            case .horizontal: return .height
            case .vertical: return .width
            }
        }
    }

    public let viewModel: ListViewModel
    public let itemsPerLine: Int
    public let factory: CollectionViewCellFactory
    public let defaultSize: CGSize

    var cellCache: [String: UIView] = [:]

    public init(
        viewModel: ListViewModel,
        factory: CollectionViewCellFactory,
        itemsPerLine: Int = 1,
        defaultSize: CGSize) {
        self.viewModel = viewModel
        self.factory = factory
        self.defaultSize = defaultSize
        self.itemsPerLine = max(1, itemsPerLine)
    }

    open func automaticSizeForItem(at indexPath: IndexPath,
                                   in collectionView: UICollectionView,
                                   direction: Direction? = nil,
                                   type: String? = nil) -> CGSize {
        let direction = direction ?? Direction.from(layout: collectionView.collectionViewLayout)
        let fixedDimension = self.calculateFixedDimension(for: direction,
                                                          collectionView: collectionView,
                                                          at: indexPath,
                                                          itemsPerLine: itemsPerLine)
        let lock = LockingSize(direction: direction, value: fixedDimension)
        return autosizeForItem(at: indexPath, type: type, lockedTo: lock)
    }

    open func autosizeForItem(at indexPath: IndexPath, type: String? = nil, lockedTo lock: LockingSize) -> CGSize {
        guard let cell = placeholderCell(at: indexPath, for: type, lockingTo: lock) else {
            return .zero
        }
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }

    open func viewModel(at indexPath: IndexPath, for type: String?) -> ViewModel? {
        let list = self.viewModel
        guard let type = type else { return list[indexPath] }

        return list.sections[indexPath.section]
            .supplementaryItem(atIndex: indexPath.item,
                  forKind: type.toSectionKind())

    }

    open func placeholderCell (at indexPath: IndexPath, for type: String?, lockingTo size: LockingSize) -> UIView? {

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
                                                   attribute: size.type,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .notAnAttribute,
                                                   multiplier: 1.0,
                                                   constant: size.value)
            content.addConstraint(newConstraint)
            constraint = newConstraint
        } else {
            constraint?.constant = size.value
        }

        cell.isPlaceholderForAutosize = true

        self.cellCache[identifier.identifierString] = cell
        (cell as? WithViewModel)?.configure(with: viewModel)
        return cell
    }

    open func sizeForItem(at indexPath: IndexPath,
                          in collectionView: UICollectionView,
                          direction: Direction? = nil,
                          type: String? = nil) -> CGSize {
        return defaultSize
    }

    open func insets(for collectionView: UICollectionView, in section: Int) -> UIEdgeInsets {
        .zero
    }

    open func itemSpacing(for collectionView: UICollectionView, in section: Int) -> CGFloat {
        0
    }

    open func lineSpacing(for collectionView: UICollectionView, in section: Int) -> CGFloat {
        0
    }

}
#endif
