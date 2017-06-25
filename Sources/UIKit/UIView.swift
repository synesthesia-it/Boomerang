//
//  UIView.swift
//  Boomerang
//
//  Created by Stefano Mondino on 25/06/17.
//
//

import UIKit
import RxCocoa
import RxSwift

public protocol EmbeddableView : class {
    var isPlaceholder:Bool { get set }
    var customContentView:UIView { get }
    
}

private struct AssociatedKeys {
    static var viewModel = "viewModel"
    static var disposeBag = "disposeBag"
    static var isPlaceholder = "isPlaceholder"
    static var collectionViewDataSource = "collectionViewDataSource"
}

public extension EmbeddableView where Self : UIView {
    
    var customContentView:UIView {
        switch self {
        case let v as UICollectionViewCell : return v.contentView
        case let v as UITableViewCell : return v.contentView
        default: return self
        }
        
        
      
    }
    
    public var isPlaceholder:Bool {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.isPlaceholder) as? Bool ?? false}
        set { objc_setAssociatedObject(self, &AssociatedKeys.isPlaceholder, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
}


