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

public typealias Scene = UIViewController
public typealias View = UIView
public typealias Image = UIImage

internal struct AssociatedKeys {
    static var disposeBag = "boomerang_disposeBag"
    static var viewModel = "boomerang_viewModel"
    static var collectionViewDelegate = "boomerang_collectionViewDelegate"
    static var collectionViewDataSource = "boomerang_collectionViewDataSource"
    static var collectionViewCacheCell = "boomerang_collectionViewCacheCell"
    static var isPlaceholderForAutosize = "boomerang_isPlaceholderForAutosize"
    
    static var tableViewDataSource = "boomerang_tableViewDataSource"
    static var tableViewDelegate = "boomerang_tableViewDelegate"
    static var tableViewCacheCell = "boomerang_tableViewCacheCell"
}

internal extension Boomerang where Base: UIView {
    var contentView: UIView {
        switch base {
        case let table as UITableViewCell: return table.contentView
        case let collection as UICollectionViewCell: return collection.contentView
        default: return base
        }
    }
}

public extension ViewModelCompatibleType where Self: NSObject {
    
    public var isPlaceholderForAutosize: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.isPlaceholderForAutosize) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isPlaceholderForAutosize, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
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


extension UIView: BoomerangCompatible { }
extension UIViewController: BoomerangCompatible { }
