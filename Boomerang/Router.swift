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

public protocol RouterDestination : ViewModelBindable {
    
}

public protocol RouterType   {
    typealias Source = RouterSource
    static func from<Source>(_ source:Source, viewModel:ViewModelType)
    static func backTo<Source>(_ source:Source, destination:RouterDestination?)
}
