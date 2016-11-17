//
//  FlowController.swift
//  Boomerang
//
//  Created by Stefano Mondino on 14/10/16.
//
//

import Foundation


public protocol RouterSource {
    
}
public protocol RouterAction {
    func execute()
}
public struct EmptyRouterAction : RouterAction {
    public func execute() {}
    public init(){}
}

public protocol RouterDestination : ViewModelBindableType {
    
}

public protocol RouterType   {
    typealias Source = RouterSource
    typealias Destination = RouterDestination
    typealias DestinationViewModel = ViewModelType
    static func from<Source,Destination,DestinationViewModel> (_ source:Source, destination:Destination, viewModel:DestinationViewModel)  -> RouterAction
    static func from<Source,DestinationViewModel>(_ source:Source, viewModel:DestinationViewModel)  -> RouterAction
    static func backTo<Source>(_ source:Source, destination:Destination?) -> RouterAction
}
extension RouterType {
    public static func from<Source,Destination,DestinationViewModel> (_ source:Source, destination:Destination, viewModel:DestinationViewModel)  -> RouterAction {
        return EmptyRouterAction()
    }
    public static func from<Source,DestinationViewModel>(_ source:Source, viewModel:DestinationViewModel)  -> RouterAction  {
        return EmptyRouterAction()
    }
    public static func backTo<Source>(_ source:Source, destination:Destination?)  -> RouterAction {
        return EmptyRouterAction()
    }
}
