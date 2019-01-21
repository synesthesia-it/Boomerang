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

open class ContentCollectionViewCell: UICollectionViewCell {
    public weak var internalView: UIView?
    ///Constraints between cell and inner view. By defaults, insets are all 0.
    public var insetConstraints: [NSLayoutConstraint] = []
    /** Binds an external itemViewModel to current cell.
     If no content view was previously set, a new one is created from nib and installed.
     View model is then properly bound to inner view.
     */
    
    public func configure(with viewModel: IdentifiableViewModelType) {
        self.boomerang.disposeBag = DisposeBag()
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
            self.insetConstraints = self.contentView.addAndFitSubview(view)
            self.internalView = view
        }
        (self.internalView as? ViewModelCompatibleType)?.set(viewModel: viewModel)
    }
}


