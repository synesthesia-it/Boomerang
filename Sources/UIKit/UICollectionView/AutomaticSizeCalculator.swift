//
//  AutomaticSizeCalculator.swift
//  Boomerang
//
//  Created by Stefano Mondino on 13/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit

open class AutomaticCollectionViewSizeCalculator: CollectionViewSizeCalculator {

    public typealias Size = (UICollectionView, IndexPath, String?) -> CGSize
    public typealias Spacing = (UICollectionView, Int) -> CGFloat
    public typealias Insets = (UICollectionView, Int) -> UIEdgeInsets
    
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
    
    private lazy var _insets: Insets = {[weak self] collectionView, section in
        return .zero
    }
    
    private lazy var _lineSpacing: Spacing = {[weak self] collectionView, section in
        return 0
    }
    private lazy var _itemSpacing: Spacing = {[weak self] collectionView, section in
        return 0
    }
    
    open func withLineSpacing(lineSpacing: @escaping Spacing) -> Self {
        self._lineSpacing = lineSpacing
        return self
    }
    open func withItemSpacing(itemSpacing: @escaping Spacing) -> Self {
        self._itemSpacing = itemSpacing
        return self
    }
    
    open func withInsets(insets: @escaping Insets) -> Self {
        self._insets = insets
        return self
    }
    
    public init(
        viewModel: ListViewModel,
        factory: CollectionViewCellFactory,
        itemsPerLine: Int = 1) {
        self.viewModel = viewModel
        self.factory = factory
        self.itemsPerLine = max(1, itemsPerLine)
    }
    
    var cellCache: [String: UIView] = [:]
    
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
        
        return list.sections[indexPath.section].supplementary.item(atIndex: indexPath.item, forKind: type.toSectionKind())
        
    }
    
    open func placeholderCell (at indexPath: IndexPath, for type: String?, lockingTo size: LockingSize) -> UIView? {
        
        guard let viewModel = self.viewModel(at: indexPath, for: type)
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
        
        cell.isPlaceholderForAutosize = true
        
        self.cellCache[identifier.identifierString] = cell
        (cell as? WithViewModel)?.configure(with: viewModel)
        return cell
    }
    open func sizeForItem(at indexPath: IndexPath,in collectionView: UICollectionView, direction: Direction? = nil, type: String? = nil) -> CGSize {
        let direction = direction ?? Direction.from(layout: collectionView.collectionViewLayout)
        let fixedDimension = self.calculateFixedDimension(for: direction, collectionView: collectionView, at: indexPath, itemsPerLine: itemsPerLine)
        let lock = LockingSize(direction: direction, value: fixedDimension)
        return autosizeForItem(at: indexPath, type: type, lockedTo: lock)
    }
    
    open func insets(for collectionView: UICollectionView, in section: Int) -> UIEdgeInsets {
        self._insets(collectionView, section)
    }
    
    open func itemSpacing(for collectionView: UICollectionView, in section: Int) -> CGFloat {
        self._itemSpacing(collectionView, section)
    }
    
    open func lineSpacing(for collectionView: UICollectionView, in section: Int) -> CGFloat {
        self._lineSpacing(collectionView, section)
    }
    
    
}
