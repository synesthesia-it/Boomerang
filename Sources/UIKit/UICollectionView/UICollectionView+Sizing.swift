//
//  UICollectionView+Sizing.swift
//  Boomerang
//
//  Created by Stefano Mondino on 26/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit

public enum Direction {
    case horizontal
    case vertical

    static func from(layout: UICollectionViewLayout) -> Direction {
        guard let flow = layout as? UICollectionViewFlowLayout else { return .vertical }
        switch flow.scrollDirection {
        case .horizontal: return .horizontal
        case .vertical: return .vertical
        @unknown default: return .vertical
        }
    }
}

public struct LockingSize {
    public var direction: Direction
    public var value: CGFloat

    var type: NSLayoutConstraint.Attribute {
        switch direction {
        case .horizontal: return .height
        case .vertical: return .width
        }
    }
}

public class UICollectionViewSizeCalculator {
    let base: UICollectionView
    let viewModel: ListViewModel
    let factory: CollectionViewCellFactory
    init(collectionView: UICollectionView,
         viewModel: ListViewModel,
         factory: CollectionViewCellFactory) {
        self.base = collectionView
        self.viewModel = viewModel
        self.factory = factory
    }

    var cellCache: [String: UIView] = [:]

    var flow: UICollectionViewFlowLayout? {
        return base.collectionViewLayout as? UICollectionViewFlowLayout
    }

    var delegate: UICollectionViewDelegateFlowLayout? {
         return base.delegate as? UICollectionViewDelegateFlowLayout
    }

    func insets(in section: Int) -> UIEdgeInsets {
        if let flow = flow {
            return delegate?.collectionView?(base, layout: flow, insetForSectionAt: section) ??
                 flow.sectionInset
        }
        return .zero
    }

    func itemSpacing(in section: Int) -> CGFloat {
        if let flow = flow {
            return delegate?.collectionView?(base, layout: flow, minimumInteritemSpacingForSectionAt: section) ?? flow.minimumInteritemSpacing
        }
        return 0
    }

    func lineSpacing(in section: Int) -> CGFloat {
        if let flow = flow {
            return delegate?.collectionView?(base, layout: flow, minimumLineSpacingForSectionAt: section) ?? flow.minimumLineSpacing
        }
        return 0
    }

    var collectionViewSize: CGSize {
        return CGSize(width: base.bounds.width - base.contentInset.left - base.contentInset.right,
                      height: base.bounds.height - base.contentInset.top - base.contentInset.top)
    }

    public func calculateFixedDimension(for direction: Direction, at indexPath: IndexPath, itemsPerLine: Int, type: String? = nil) -> CGFloat {
        if type == UICollectionView.elementKindSectionHeader || type == UICollectionView.elementKindSectionFooter {
            switch direction {
            case .vertical:
                return collectionViewSize.width
            case .horizontal:
                return collectionViewSize.height
            }
        }
        let itemsPerLine = CGFloat(itemsPerLine)
        let insets = self.insets(in: indexPath.section)
        let itemSpacing = self.itemSpacing(in: indexPath.section)
        let value: CGFloat
        switch direction {
        case .vertical:
            value = (collectionViewSize.width - insets.left - insets.right - (itemsPerLine - 1) * itemSpacing) / itemsPerLine
        case .horizontal:
            value = (collectionViewSize.height - insets.top - insets.bottom - (itemsPerLine - 1) * itemSpacing) / itemsPerLine
        }
        return floor(value * UIScreen.main.scale)/UIScreen.main.scale
    }

    private func properViewModel(at indexPath: IndexPath, for type: String?) -> ViewModel? {
        let list = self.viewModel

        guard let type = type else { return list[indexPath] }

        return list.sections[indexPath.section].supplementary.item(atIndex: indexPath.item, forKind: type.toSectionKind())

    }
    func placeholderCell (at indexPath: IndexPath, for type: String?, lockingTo size: LockingSize) -> UIView? {

       guard let viewModel = self.properViewModel(at: indexPath, for: type)
       else {
                return nil
        }
        let identifier = viewModel.layoutIdentifier
        guard let cell: UIView = cellCache[identifier.identifierString] ?? factory.view(from: identifier) else { return nil }

       let content = cell//.boomerang.contentView
        content.translatesAutoresizingMaskIntoConstraints = false

       var constraint = content.constraints.filter {
            ($0.firstItem as? UIView) == content && $0.firstAttribute == .width && $0.secondItem == nil && $0.secondAttribute == .notAnAttribute
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
        ///TODO Placeholder
//        (cell as? (UIView & WithViewModel))?.isPlaceholderForAutosize = true

        self.cellCache[identifier.identifierString] = cell
        (cell as? WithViewModel)?.configure(with: viewModel)
        return cell
    }
    public func automaticSizeForItem(at indexPath: IndexPath, type: String? = nil, lockedTo lock: LockingSize) -> CGSize {
        guard let cell = placeholderCell(at: indexPath, for: type, lockingTo: lock) else {
            return .zero
        }
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }

    public func automaticSizeForItem(at indexPath: IndexPath, direction: Direction? = nil, type: String? = nil, itemsPerLine: Int = 1) -> CGSize {
        let direction = direction ?? Direction.from(layout: base.collectionViewLayout)
        let fixedDimension = self.calculateFixedDimension(for: direction, at: indexPath, itemsPerLine: itemsPerLine)
        let lock = LockingSize(direction: direction, value: fixedDimension)
        return automaticSizeForItem(at: indexPath, type: type, lockedTo: lock)
    }
}
