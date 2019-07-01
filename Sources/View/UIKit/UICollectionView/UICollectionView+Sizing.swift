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
    
    public init(direction: Direction, value: CGFloat) {
        self.direction = direction
        self.value = value
    }
    
    var type: NSLayoutConstraint.Attribute {
        switch direction {
        case .horizontal: return .height
        case .vertical: return .width
        }
    }
}

extension Boomerang where Base: UICollectionView {
    
    var cellCache: [String: UIView] {
        get {
            guard let lookup = objc_getAssociatedObject(base, &AssociatedKeys.collectionViewCacheCell) as? [String: UIView] else {
                let newValue = [String: UIView]()
                objc_setAssociatedObject(base, &AssociatedKeys.collectionViewCacheCell, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return newValue
            }
            return lookup
        }
        nonmutating set {
            objc_setAssociatedObject(base, &AssociatedKeys.collectionViewCacheCell, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var flow: UICollectionViewFlowLayout? {
        return base.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    var delegate: UICollectionViewDelegateFlowLayout? {
         return base.delegate as? UICollectionViewDelegateFlowLayout
    }
    
    func insets(in section:Int) -> UIEdgeInsets {
        if let delegate = delegate {
            return delegate.collectionView?(base, layout: base.collectionViewLayout, insetForSectionAt: section) ?? (flow?.sectionInset ?? .zero)
        }
        return .zero
    }
    
    func itemSpacing(in section: Int) -> CGFloat {
        if let delegate = delegate {
            return delegate.collectionView?(base, layout: base.collectionViewLayout, minimumInteritemSpacingForSectionAt: section) ?? (flow?.minimumInteritemSpacing ?? 0)
        }
        return 0
    }
    
    func lineSpacing(in section: Int) -> CGFloat {
        if let delegate = delegate {
            return delegate.collectionView?(base, layout: base.collectionViewLayout, minimumLineSpacingForSectionAt: section) ?? (flow?.minimumLineSpacing ?? 0)
        }
        return 0
    }
    
    var collectionViewSize: CGSize {
        return CGSize(width: base.bounds.width - base.contentInset.left - base.contentInset.right,
                      height: base.bounds.height - base.contentInset.top - base.contentInset.top)
    }
    
    public func calculateFixedDimension(for direction:Direction, at indexPath: IndexPath, itemsPerLine: Int) -> CGFloat {
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
    private func properViewModel(at indexPath: IndexPath, for type: String?) -> IdentifiableViewModelType?{
        guard let list = self.internalDataSource?.viewModel else { return nil }
        guard let type = type else { return list.mainViewModel(at: indexPath)}
        return list.supplementaryViewModel(at: indexPath, for: type)
    }
    func placeholderCell (at indexPath: IndexPath, for type: String?, lockingTo size: LockingSize) -> UIView? {
        guard let list = self.internalDataSource?.viewModel,
            let viewModel = self.properViewModel(at: indexPath, for: type),
        let identifier = (list.identifier(at: indexPath, for: type) as? ViewIdentifier ?? viewModel.identifier) as? ViewIdentifier,
        let cell: UIView = cellCache[identifier.name] ?? identifier.view()
        else {
                return nil
        }
        
       let content = cell.boomerang.contentView
        content.translatesAutoresizingMaskIntoConstraints = false
        
       var constraint = content.constraints.filter {
            ($0.firstItem as? UIView) == content && $0.firstAttribute == .width && $0.secondItem == nil && $0.secondAttribute == .notAnAttribute
        }.first
        if constraint == nil {
        let newConstraint = NSLayoutConstraint(item: cell.boomerang.contentView,
                                            attribute: size.type,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1.0,
                                            constant: size.value)
            cell.boomerang.contentView.addConstraint(newConstraint)
            constraint = newConstraint
        } else {
            constraint?.constant = size.value
        }
        
        (cell as? (UIView & ViewModelCompatibleType))?.isPlaceholderForAutosize = true
        
        self.cellCache[identifier.name] = cell
        (cell as? ViewModelCompatibleType)?.set(viewModel: viewModel)
        return cell
    }
    public func automaticSizeForItem(at indexPath: IndexPath, type: String? = nil, lockedTo lock: LockingSize) -> CGSize {
        guard let cell = placeholderCell(at: indexPath, for: type, lockingTo: lock) else {
            return .zero
        }
        cell.boomerang.contentView.setNeedsLayout()
        cell.boomerang.contentView.layoutIfNeeded()
        return cell.boomerang.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    public func automaticSizeForItem(at indexPath: IndexPath, direction: Direction? = nil, type:String? = nil, itemsPerLine: Int = 1) -> CGSize {
        let direction = direction ?? Direction.from(layout: base.collectionViewLayout)
        let fixedDimension = self.calculateFixedDimension(for: direction, at: indexPath, itemsPerLine: itemsPerLine)
        let lock = LockingSize(direction: direction, value: fixedDimension)
        return automaticSizeForItem(at: indexPath, type: type, lockedTo: lock)
    }
}
