//
//  UIRouter.swift
//  Boomerang
//
//  Created by Stefano Mondino on 11/11/16.
//
//

import UIKit



public enum UIViewControllerRouterAction : RouterAction {
    case push (source:UIViewController, destination:UIViewController)
    case pop (source:UIViewController)
    case dismiss (source:UIViewController, completion: (() -> Void)?)
    case modal(source:UIViewController, destination:UIViewController, completion: (() -> Void)?)
    case custom(action:(() -> Void))
    public func execute() {
        switch self {
        case .push (let source, let destination) :
            source.navigationController?.pushViewController(destination, animated: true)
            break
        case .dismiss(let source, let completion) :
            source.presentingViewController?.dismiss(animated: true, completion: completion)
            break
        case .pop (let source) :
            _ = source.navigationController?.popViewController(animated: true)
            break
            
        case .modal (let source, let destination, let completion) :
            source.present(destination, animated: true, completion: completion)
            break
        
        case .custom (let action) :
            action()
            break

        }
    }
    
}

