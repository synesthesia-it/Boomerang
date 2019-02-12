//
//  UITableView+Sizing.swift
//  Boomerang
//
//  Created by Alberto Bo on 08/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//


import Foundation
import UIKit

extension Boomerang where Base: UITableView {
    
    var cellCache: [String: UIView] {
        get {
            guard let lookup = objc_getAssociatedObject(base, &AssociatedKeys.tableViewCacheCell) as? [String: UIView] else {
                let newValue = [String: UIView]()
                objc_setAssociatedObject(base, &AssociatedKeys.tableViewCacheCell, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return newValue
            }
            return lookup
        }
        nonmutating set {
            objc_setAssociatedObject(base, &AssociatedKeys.tableViewCacheCell, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var delegate: UITableViewDelegate? {
        return base.delegate
    }

    var tableViewSize: CGSize{
        return CGSize(width: base.bounds.width - base.contentInset.left - base.contentInset.right,
                      height: base.bounds.height - base.contentInset.top - base.contentInset.top)
    }

    private func properViewModel(at indexPath: IndexPath, for type: String?) -> IdentifiableViewModelType?{
        guard let list = self.internalDataSource?.viewModel else { return nil }
        guard let type = type else { return list.mainViewModel(at: indexPath)}
        return list.supplementaryViewModel(at: indexPath, for: type)
    }
    
    func placeholderCell (at indexPath: IndexPath, for type: String?) -> UIView? {
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
                                                   attribute: .width,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .notAnAttribute,
                                                   multiplier: 1.0,
                                                   constant: tableViewSize.width)
            cell.boomerang.contentView.addConstraint(newConstraint)
            constraint = newConstraint
        } else {
            constraint?.constant = tableViewSize.width
        }
        
        (cell as? (UIView & ViewModelCompatibleType))?.isPlaceholderForAutosize = true
        
        self.cellCache[identifier.name] = cell
        (cell as? ViewModelCompatibleType)?.set(viewModel: viewModel)
        return cell
    }
    
    public func automaticSizeForRow(at indexPath: IndexPath, type: String? = nil) -> CGFloat {
        guard let cell = placeholderCell(at: indexPath, for: type) else {
            return base.rowHeight
        }
        cell.boomerang.contentView.setNeedsLayout()
        cell.boomerang.contentView.layoutIfNeeded()
        return cell.boomerang.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
    }
}

