//
//  Router.swift
//  Boomerang
//
//  Created by Stefano Mondino on 13/11/16.
//
//

import Foundation
import Boomerang
import UIKit

struct Router : RouterType {
    
}

extension RouterType {
    static func from<Source>(_ source:Source, viewModel:ViewModelType) -> RouterAction where Source : ViewController {
        
        let vc = self.viewController(storyboardId: "Main", storyboardIdentifier: "testViewController") as! ViewController
        vc.bindTo(viewModel:viewModel, afterLoad:true)
        return UIViewControllerRouterAction.push(source:source, destination:vc)
    }
    
    static func viewController(storyboardId:String, storyboardIdentifier:String) -> RouterSource {
        return UIStoryboard(name: storyboardId, bundle: nil).instantiateViewController(withIdentifier: storyboardIdentifier)
    }
    
    
    static func backTo<Source>(_ source:Source, destination:RouterDestination?) -> RouterAction where Source : ViewController  {
        return UIViewControllerRouterAction.pop(source:source)
    }
}
