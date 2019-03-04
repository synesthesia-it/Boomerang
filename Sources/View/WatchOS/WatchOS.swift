//
//  WatchOS.swift
//  Boomerang-watch
//
//  Created by Stefano Mondino on 04/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import WatchKit
import RxCocoa
import RxSwift

public typealias Scene = WKInterfaceController
public typealias View = NSObject
public typealias Image = UIImage

extension NSObject: BoomerangCompatible { }

internal struct AssociatedKeys {
    static var disposeBag = "boomerang_disposeBag"
    static var viewModel = "boomerang_viewModel"
}

public extension ViewModelCompatibleType where Self: NSObject {
    
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


