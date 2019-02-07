//
//  Router.swift
//  Boomerang
//
//  Created by Stefano Mondino on 05/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public protocol Route {
    var destination: Scene? { get }
}

public protocol ViewModelRoute: Route {
    var viewModel: SceneViewModelType { get }
}

extension ViewModelRoute {
    public var destination: Scene? {
        return viewModel.sceneIdentifier.scene()
    }
}

extension Route {
    static var typeIdentifier: ObjectIdentifier {
        return ObjectIdentifier(self)
    }
}

public struct Router {
    
    private struct ClosureWrapper {
        let closure: (Route, Scene?) -> ()
    }
    
    private static var routeHandlers: [ObjectIdentifier: Router.ClosureWrapper ] = [:]
    
    public static func register<RouteType: Route>(_ type: RouteType.Type, handler: @escaping (RouteType, Scene?) -> () ) {
        routeHandlers[type.typeIdentifier] = ClosureWrapper(closure: {
            guard let route = $0 as? RouteType else { return }
            handler(route, $1) })
    }
    
    public static func execute(_ route: Route, from source: Scene?) {
        let routeType = type(of: route)
        if let handler = routeHandlers[routeType.typeIdentifier]?.closure {
            handler(route, source)
        }
    }
}
