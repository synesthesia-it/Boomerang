//
//  FlowController.swift
//  Boomerang
//
//  Created by Stefano Mondino on 14/10/16.
//
//

import Foundation


public protocol RouteData {
    var viewModel:ViewModelType? {get set}
    var route: Route? {get set}
}
public protocol Route {
    
}

//public enum RouterAction : RouterActionType {
//    case Identifier
//    case Segue
//    case Action
//    case Custom
//    case None
//}


protocol RouterType {
    
}
