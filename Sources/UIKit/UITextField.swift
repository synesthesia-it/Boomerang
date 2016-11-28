//
//  UILabel.swift
//  Boomerang
//
//  Created by Stefano Mondino on 21/11/16.
//
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

private struct AssociatedKeys {
    static var viewModel = "viewModel"
    static var disposable = "disposable"
    
}
extension UITextField : ViewModelBindable {
    
    public var viewModel: ViewModelType? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.viewModel) as? ViewModelType}
        set { objc_setAssociatedObject(self, &AssociatedKeys.viewModel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
    
    public var disposable: CompositeDisposable? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.disposable) as? CompositeDisposable}
        set { objc_setAssociatedObject(self, &AssociatedKeys.disposable, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
    
    public func bind(_ viewModel: ViewModelType?) {
        self.viewModel = viewModel
        guard let vm = viewModel as? TextInput else {
            return
        }
        self.placeholder = vm.title
        self.disposable?.dispose()
        self.disposable = CompositeDisposable()
        self.disposable?.add(self.reactive.text <~ vm.string.skipRepeats().producer.delay(0.0, on: QueueScheduler.main))
        self.disposable?.add(vm.string <~ self.reactive.continuousTextValues.skipNil().skipRepeats())
    }

    
    
    
}

extension UITextView : ViewModelBindable {
    
    public var viewModel: ViewModelType? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.viewModel) as? ViewModelType}
        set { objc_setAssociatedObject(self, &AssociatedKeys.viewModel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
    
    public var disposable: CompositeDisposable? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.disposable) as? CompositeDisposable}
        set { objc_setAssociatedObject(self, &AssociatedKeys.disposable, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
    
    public func bind(_ viewModel: ViewModelType?) {
        self.viewModel = viewModel
        guard let vm = viewModel as? TextInput else {
            return
        }
        
        self.disposable?.dispose()
        self.disposable = CompositeDisposable()
        
        self.disposable?.add(self.reactive.text <~ vm.string.skipRepeats().producer.delay(0.0, on: QueueScheduler.main))
        self.disposable?.add(vm.string <~ self.reactive.continuousTextValues.skipRepeats())
    }
    
    
    
    
}
