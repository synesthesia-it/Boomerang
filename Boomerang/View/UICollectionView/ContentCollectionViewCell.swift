//
//  ContentCollectionViewCell.swift
//  Boomerang
//
//  Created by Stefano Mondino on 20/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

open class ContentCollectionViewCell: UICollectionViewCell, ViewModelCompatibleType {
 
    public private(set) weak var internalView: UIView?
    ///Constraints between cell and inner view.
    public private(set) var insetConstraints: [NSLayoutConstraint] = []
    
    ///Insets between cell and innerView. By default, insets are all 0
    public var insets: UIEdgeInsets = .zero {
        didSet {
            if self.internalView != nil {
                insetConstraints.forEach { self.internalView?.removeConstraint($0)}
                insetConstraints = self.fitInSuperview(with: insets)
            }
        }
    }
    /** Binds an external itemViewModel to current cell.
     If no content view was previously set, a new one is created from nib and installed.
     View model is then properly bound to inner view.
     */
    
    open func set(viewModel: ViewModelType?) {
        guard let viewModel = viewModel as? IdentifiableViewModelType else { return }
        
        self.disposeBag = DisposeBag()
        
        if (self.internalView == nil) {
            let view: UIView
            if let className = (viewModel.identifier as? ReusableListIdentifier)?.className {
                guard let innerView = (className as? UIView.Type)?.init() else {
                    return
                }
                view = innerView
            } else {
            guard let innerView = Bundle.main.loadNibNamed(viewModel.identifier.name, owner: self, options: nil)?.first as? UIView else {
                return
            }
                view = innerView
            }
            self.contentView.addSubview(view)
            self.insetConstraints = self.contentView.fitInSuperview(with: insets)
            self.internalView = view
        }
        (self.internalView as? ViewModelCompatibleType)?.set(viewModel: viewModel)
    }
}


