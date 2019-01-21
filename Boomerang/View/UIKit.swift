//
//  UIView.swift
//  Boomerang
//
//  Created by Stefano Mondino on 20/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

internal struct AssociatedKeys {
    static var disposeBag = "boomerang_disposeBag"
    static var viewModel = "boomerang_viewModel"
    static var collectionViewDataSource = "boomerang_collectionViewDataSource"
}

extension Boomerang where Base: NSObject {
    public var disposeBag: DisposeBag {
        get {
            guard let lookup = objc_getAssociatedObject(base, &AssociatedKeys.disposeBag) as? DisposeBag else {
                let value = DisposeBag()
                objc_setAssociatedObject(base, &AssociatedKeys.disposeBag, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return value
            }
            return lookup
        }
        set {
            objc_setAssociatedObject(base, &AssociatedKeys.disposeBag, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension Boomerang where Base: NSObject, Base: ViewModelCompatible {
    
    var viewModel: Base.ViewModel? {
        get {
            return objc_getAssociatedObject(base, &AssociatedKeys.viewModel) as? Base.ViewModel
        }
        set {
            objc_setAssociatedObject(base, &AssociatedKeys.viewModel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    
}
