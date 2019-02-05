//
//  Router.swift
//  Boomerang
//
//  Created by Stefano Mondino on 05/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public protocol Route {
    typealias S = Scene
    var destination: S? { get }
}

public protocol ViewModelRoute: Route {
    var viewModel: SceneViewModelType { get set }
}

extension ViewModelRoute {
    public var destination: S? {
        return viewModel.sceneIdentifier.scene()
    }
}

extension Route {
    static var typeIdentifier: ObjectIdentifier {
        return ObjectIdentifier(self)
    }
}

public struct Router {
    
    private static var routeHandlers: [ObjectIdentifier: Any] = [:]
    
    public static func register<RouteType: Route>(_ type: RouteType.Type, handler: @escaping (RouteType, Scene?) -> () ) {
        routeHandlers[type.typeIdentifier] = handler
    }
    
    public static func execute<RouteType: Route>(_ route: RouteType, from source: Scene?) {
        if let handler = routeHandlers[type(of: route).typeIdentifier] as? ((RouteType, Scene?) -> ()) {
            handler(route, source)
        }
    }
}
