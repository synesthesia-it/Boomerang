//
//  ViewController.swift
//  Boomerang
//
//  Created by Stefano Mondino on 13/10/16.
//
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Action

 extension UIViewController : RouterSource {
    
}


public protocol LoaderReceiver {
    func showLoader()
    func hideLoader()
}
public protocol ErrorReceiver {
    func showError(_ error:ActionError)
}

public protocol ViewControllerActionBindable {
     func showLoader()
     func hideLoader()
     func showError(_ error:ActionError)
}

public extension ViewControllerActionBindable where Self: UIViewController {
    public func bindTo(observable:Observable<ActionError>) -> Disposable {
        return observable.subscribe(onNext: {[weak self] error in
                self?.showError(error)
        })
    }
    
    public func bindTo<Input,Output>(action:Action<Input,Output>) -> Disposable {
        let disposable = CompositeDisposable()
        
        _ = disposable.insert(self.bindTo(observable:action.errors))
        _ = disposable.insert(self.bindTo(observable:action.executing))
        return disposable
    }
    public func bindTo(observable:Observable<Bool>) -> Disposable {
        return observable.subscribe(onNext: {[weak self] isLoading in
             isLoading ? self?.showLoader() : self?.hideLoader()
        })
    }
}

public extension ViewModelBindableType where Self : UIViewController {
    
    public func bind(to viewModel: ViewModelType? , afterLoad:Bool) {
        if (afterLoad) {
            (self as UIViewController).rx.sentMessage(#selector(viewDidLoad)).take(1).subscribe(onCompleted: {[weak self] _ in
                self?.bind(to:viewModel)
            }).addDisposableTo(self.disposeBag)
        }
        
        else {
            self.bind(to: viewModel)
        }
    }
   
    
}
