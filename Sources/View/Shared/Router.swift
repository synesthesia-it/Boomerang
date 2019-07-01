//
//  Router.swift
//  Boomerang
//
//  Created by Stefano Mondino on 05/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public protocol Route: DependencyKey {
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

public extension Route {
    var dependencyKey: KeyType { return -1 }
}

public struct Router {
    
    internal struct RouterContainer: DependencyContainer {
        static var container: Container<Int, Router.Value> = Container()
    }
    
    public typealias Value = ClosureWrapper
    
    
    public struct ClosureWrapper {
        let closure: (Route, Scene?) -> ()
        init(closure: @escaping (Route, Scene?) -> ()) {
            self.closure = closure
        }
    }
    public static func register<RouteType: Route>(_ type: RouteType.Type, handler: @escaping (RouteType, Scene?) -> () ) {
        
        RouterContainer.register(type) { () -> Value in
            ClosureWrapper {
                guard let route = $0 as? RouteType else { return }
                handler(route, $1)
            }
            
        }

    }
    public static func execute(_ route: Route, from source: Scene?) {
//
        if let routeType: DependencyKey.Type = type(of: route) as? DependencyKey.Type {
//            self.resolve(routeType)
            RouterContainer.resolve(routeType)?.closure(route,source)
        }

    }
}
