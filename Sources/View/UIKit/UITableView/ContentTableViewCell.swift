//
//  ContentTableViewCell.swift
//  Boomerang
//
//  Created by Alberto Bo on 08/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//


import Foundation
import UIKit
import RxSwift

public protocol TableViewCellContained {
//    func apply(_ layoutAttributes: UICollectionViewLayoutAttributes)
}

public protocol ContentTableViewCellType: NSObjectProtocol, ViewModelCompatibleType {
    var internalView: UIView? { get set }
    ///Constraints between cell and inner view.
    var insetConstraints: [NSLayoutConstraint] { get set }
}


extension ContentTableViewCellType where Self: UITableViewCell {
    
    /** Binds an external itemViewModel to current cell.
     If no content view was previously set, a new one is created from nib and installed.
     View model is then properly bound to inner view.
     */
    
    public func set(viewModel: ViewModelType) {
        guard let viewModel = viewModel as? IdentifiableViewModelType else { return }
        
        self.disposeBag = DisposeBag()
        
        if (self.internalView == nil) {
            guard let view: UIView = (viewModel.identifier as? ViewIdentifier)?.view() else { return }
            self.backgroundColor = .clear
            self.contentView.addSubview(view)
            self.insetConstraints = view.fitInSuperview(with: .zero)
            self.internalView = view
        }
        (self.internalView as? ViewModelCompatibleType)?.set(viewModel: viewModel)
    }
    
}

extension ContentTableViewCellType where Self: UITableViewHeaderFooterView {
    
    /** Binds an external itemViewModel to current cell.
     If no content view was previously set, a new one is created from nib and installed.
     View model is then properly bound to inner view.
     */
    
    public func set(viewModel: ViewModelType) {
        guard let viewModel = viewModel as? IdentifiableViewModelType else { return }
        
        self.disposeBag = DisposeBag()
        
        if (self.internalView == nil) {
            guard let view: UIView = (viewModel.identifier as? ViewIdentifier)?.view() else { return }
            self.backgroundColor = .clear
            self.contentView.addSubview(view)
            self.insetConstraints = view.fitInSuperview(with: .zero)
            self.internalView = view
        }
        (self.internalView as? ViewModelCompatibleType)?.set(viewModel: viewModel)
    }
    
}

public class ContentTableViewCell: UITableViewCell, ContentTableViewCellType {
    
    public weak var internalView: UIView?
    ///Constraints between cell and inner view.
    public var insetConstraints: [NSLayoutConstraint] = []
    
//    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
//        super.apply(layoutAttributes)
//        (internalView as? CollectionViewCellContained)?.apply(layoutAttributes)
//    }
    
    open override var canBecomeFocused: Bool {
        return internalView?.canBecomeFocused ?? super.canBecomeFocused
    }
    open override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return internalView?.preferredFocusEnvironments ?? super.preferredFocusEnvironments
    }
    open override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        return internalView?.didUpdateFocus(in:context, with: coordinator) ?? super.didUpdateFocus(in: context, with: coordinator)
    }
}

open class ContentTableHeaderFooterView: UITableViewHeaderFooterView, ContentTableViewCellType {
 
    public weak var internalView: UIView?
    ///Constraints between cell and inner view.
    public var insetConstraints: [NSLayoutConstraint] = []
    
    //    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
    //        super.apply(layoutAttributes)
    //        (internalView as? CollectionViewCellContained)?.apply(layoutAttributes)
    //    }
    
 
    public func set(viewModel: ViewModelType) {
        
        guard let viewModel = viewModel as? IdentifiableViewModelType else { return }
        
        self.disposeBag = DisposeBag()
        
        if (self.internalView == nil) {
            guard let view: UIView = (viewModel.identifier as? ViewIdentifier)?.view() else { return }
            self.backgroundColor = .clear
            self.contentView.addSubview(view)
            self.insetConstraints = view.fitInSuperview(with: .zero)
            self.internalView = view
        }
        (self.internalView as? ViewModelCompatibleType)?.set(viewModel: viewModel)
    }
    
    
    
    open override var canBecomeFocused: Bool {
        return internalView?.canBecomeFocused ?? super.canBecomeFocused
    }
    open override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return internalView?.preferredFocusEnvironments ?? super.preferredFocusEnvironments
    }
    open override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        return internalView?.didUpdateFocus(in:context, with: coordinator) ?? super.didUpdateFocus(in: context, with: coordinator)
    }
}
