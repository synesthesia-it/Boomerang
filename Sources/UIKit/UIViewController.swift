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
    public func bind(_ observable:Observable<ActionError>) -> Disposable {
        return observable.subscribe(onNext: {[weak self] error in
                self?.showError(error)
        })
    }
    
    public func bind<Input,Output>(_ action:Action<Input,Output>) -> Disposable {
        let disposable = CompositeDisposable()
        
        _ = disposable.insert(self.bind(action.errors))
        _ = disposable.insert(self.bind(action.executing))
        return disposable
    }
    public func bind(_ observable:Observable<Bool>) -> Disposable {
        return observable.subscribe(onNext: {[weak self] isLoading in
             isLoading ? self?.showLoader() : self?.hideLoader()
        })
    }
}

public extension ViewModelBindable where Self : UIViewController {
    
    public func bindTo(viewModel: ViewModelType? , afterLoad:Bool) {
        if (afterLoad) {
            (self as UIViewController).rx.sentMessage(#selector(viewDidLoad)).take(1).subscribe(onCompleted: {[weak self] _ in
                self?.bindTo(viewModel:viewModel)
            }).addDisposableTo(self.disposeBag)
        }
        
        else {
            self.bindTo(viewModel:viewModel)
        }
    }
   
    
}
