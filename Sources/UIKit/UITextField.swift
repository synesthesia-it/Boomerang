//
//  UILabel.swift
//  Boomerang
//
//  Created by Stefano Mondino on 21/11/16.
//
//

import UIKit
import RxSwift
import RxCocoa


private struct AssociatedKeys {
    static var viewModel = "viewModel"
    static var disposeBag = "boomerang_disposeBag"
    
}
extension UITextField : ViewModelBindable {
    
    public var viewModel: ViewModelType? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.viewModel) as? ViewModelType}
        set { objc_setAssociatedObject(self, &AssociatedKeys.viewModel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
    
    public var disposeBag: DisposeBag {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.disposeBag) as! DisposeBag}
        set { objc_setAssociatedObject(self, &AssociatedKeys.disposeBag, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
    
    public func bind(to viewModel: ViewModelType?) {
        self.viewModel = viewModel
        guard let viewModel = viewModel as? TextInput else {
            return
        }
        self.placeholder = viewModel.title
        
        self.disposeBag = DisposeBag()
        self.text = viewModel.string.value
        self.rx.text.map { $0 ?? ""}.bind(to: viewModel.string).addDisposableTo(self.disposeBag)
        
    }
    
    
    
    
}

extension UITextView : ViewModelBindable {
    
    public var viewModel: ViewModelType? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.viewModel) as? ViewModelType}
        set { objc_setAssociatedObject(self, &AssociatedKeys.viewModel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
    
    public var disposeBag: DisposeBag {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.disposeBag) as! DisposeBag}
        set { objc_setAssociatedObject(self, &AssociatedKeys.disposeBag, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
    
    public func bind(to viewModel: ViewModelType?) {
        self.viewModel = viewModel
        guard let viewModel = viewModel as? TextInput else {
            return
        }
        self.disposeBag = DisposeBag()
        self.text = viewModel.string.value
        self.rx.text.map { $0 ?? ""}.bind(to: viewModel.string).addDisposableTo(self.disposeBag)
    }
    
    
    
    
}
