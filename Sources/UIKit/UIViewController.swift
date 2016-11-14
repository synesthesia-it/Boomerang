//
//  ViewController.swift
//  Boomerang
//
//  Created by Stefano Mondino on 13/10/16.
//
//

import Foundation

import Foundation
import UIKit
import ReactiveSwift
import ReactiveCocoa

import Result

 extension UIViewController : RouterSource {
    
}


public protocol LoaderReceiver {
    func showLoader()
    func hideLoader()
}
public protocol ErrorReceiver {
    func showError(_ error:NSError)
}


public extension ViewModelBindable where Self : UIViewController {
    
//    public func performSegueWithIdentifier(_ identifier:String!, viewModel:ViewModel?) {
//        
//        
//        let signalProducer:SignalProducer<UIViewController,NSError>  = self.rac_signal(for: #selector(prepare(for:sender:)))
//            .toSignalProducer()
//            .take(first:1)
//            .map({
//                let segue:UIStoryboardSegue = ($0! as! RACTuple).first as! UIStoryboardSegue
//                return segue.destination
//            }).flatMap(.latest) { (viewController:UIViewController) -> SignalProducer<UIViewController, NSError> in
//                if (viewController is UINavigationController) {
//                    let vc = (viewController as! UINavigationController).topViewController
//                    return SignalProducer<UIViewController, NSError>(value:vc!)
//                }
//                return SignalProducer<UIViewController, NSError>(value:viewController)
//            }.flatMap(.latest) {[weak self] vc in
//                return self?.viewDidLoadSignalProducer().take(first: 1).map {_ in return vc} ?? SignalProducer(value:vc)
//        }
//        signalProducer.startWithResult { (result) in
//            result.value?.bindViewModel(viewModel)
//        }
//        
//        self.performSegue(withIdentifier: identifier, sender: self)
//    }

//    private func viewDidLoadSignalProducer() -> SignalProducer<Bool,NoError> {
//        let signalProducer:SignalProducer<Bool,NoError> = self
//            .rac_signal(for: #selector(UIViewController.viewDidLoad)).toSignalProducer()
//            .flatMapError({_ in return .empty})
//            .map({_ in
//                return true
//            })
//        
//        return signalProducer
//    }
//    
//    public func viewWillAppearSignalProducer() -> SignalProducer<Bool,NoError> {
//        let signalProducer:SignalProducer<Bool,NoError> = self
//            .rac_signal(for: #selector(UIViewController.viewWillAppear(_:))).toSignalProducer()
//            .flatMapError({_ in return .empty})
//            .map({
//                let animated:Bool = ($0! as! RACTuple).first as! Bool
//                return animated
//            })
//        
//        return signalProducer
//    }
//    public func viewDidAppearSignalProducer() -> SignalProducer<Bool,NoError> {
//        let signalProducer:SignalProducer<Bool,NoError> = self
//            .rac_signal(for: #selector(UIViewController.viewDidAppear(_:))).toSignalProducer()
//            .flatMapError({_ in return .empty})
//            .map({
//                let animated:Bool = ($0! as! RACTuple).first as! Bool
//                return animated
//            })
//        
//        return signalProducer
//    }
//    public func viewWillDisappearSignalProducer() -> SignalProducer<Bool,NoError> {
//        let signalProducer:SignalProducer<Bool,NoError> = self
//            .rac_signal(for: #selector(UIViewController.viewWillDisappear(_:))).toSignalProducer()
//            .flatMapError({_ in return .empty})
//            .map({
//                let animated:Bool = ($0! as! RACTuple).first as! Bool
//                return animated
//            })
//        
//        return signalProducer
//    }
//    public func viewDidDisappearSignalProducer() -> SignalProducer<Bool,NoError> {
//        let signalProducer:SignalProducer<Bool,NoError> = self
//            .rac_signal(for: #selector(UIViewController.viewDidDisappear(_:))).toSignalProducer()
//            .flatMapError({_ in return .empty})
//            .map({
//                let animated:Bool = ($0! as! RACTuple).first as! Bool
//                return animated
//            })
//        
//        return signalProducer
//    }
    
    public mutating func bindViewModel(_ viewModel:ViewModel?) {
        self.viewModel = viewModel
        guard let vm = viewModel as? ListViewModelType else {
            return
        }
        
        
//        _ = vm.reloadAction?.errors.observeResult({[weak self] (result) in
//            self?.showError(result.value!)
//            })
//        vm.reloadAction?.isExecuting.producer.startWithResult({[weak self] (result) in
//            if (result.value == true)  {
//                self?.showLoader()
//            }
//            else {
//                self?.hideLoader()
//            }        })
    }
    public func bindViewModelAfterLoad(_ viewModel: ViewModelType?) {
        _ = (self as UIViewController).reactive.trigger(for: #selector(viewDidLoad)).take(first:1).observeCompleted {
            self.bindViewModel(viewModel)
        }
    }
    
    public func showLoader() {
        print ("Showing loader")
    }
    public func hideLoader() {
        print ("Hiding loader")
    }
    public func showError(_ error:NSError) {
        print ("Showing error :\(error)")
    }
    
}
