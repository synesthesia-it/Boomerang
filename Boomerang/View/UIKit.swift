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

extension ViewModelCompatibleType where Self: NSObject {
    public var disposeBag: DisposeBag {
        get {
            guard let lookup = objc_getAssociatedObject(self, &AssociatedKeys.disposeBag) as? DisposeBag else {
                let value = DisposeBag()
                objc_setAssociatedObject(self, &AssociatedKeys.disposeBag, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return value
            }
            return lookup
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.disposeBag, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public extension ViewModelCompatible where Self: NSObject {
    
    var viewModel: ViewModel? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.viewModel) as? ViewModel
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.viewModel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

