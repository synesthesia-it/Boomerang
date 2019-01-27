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

public protocol CollectionViewCellContained {
    func apply(_ layoutAttributes: UICollectionViewLayoutAttributes)
}

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

    open func set(viewModel: ViewModelType) {
        guard let viewModel = viewModel as? IdentifiableViewModelType else { return }
        
        self.disposeBag = DisposeBag()
        
        if (self.internalView == nil) {
            guard let view: UIView = (viewModel.identifier as? ViewIdentifier)?.view() else { return }
            
            self.contentView.addSubview(view)
            self.insetConstraints = view.fitInSuperview(with: insets)
            self.internalView = view
        }
        (self.internalView as? ViewModelCompatibleType)?.set(viewModel: viewModel)
    }
    
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        (internalView as? CollectionViewCellContained)?.apply(layoutAttributes)
    }
}


