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
    var viewModel: ItemViewModel { get }
}

//extension ViewModelRoute {
//    public var destination: Scene? {
//        return viewModel.sceneIdentifier.scene()
//    }
//}

public extension Route {
    var dependencyKey: KeyType { return -1 }
}

public class Router {
    
    private var container: Container<Int, Router.Value> = Container()
    public typealias Value = ClosureWrapper
    
    public static let shared = Router()
    
    public struct ClosureWrapper {
        let closure: (Route, Scene?) -> ()
        init(closure: @escaping (Route, Scene?) -> ()) {
            self.closure = closure
        }
    }
    public func register<RouteType: Route>(_ type: RouteType.Type, handler: @escaping (RouteType, Scene?) -> () ) {
        
        container.register(for: type.dependencyKey) { () -> Value in
            ClosureWrapper {
                guard let route = $0 as? RouteType else { return }
                handler(route, $1)
            }
        }
    }
    public func execute(_ route: Route, from source: Scene?) {
            container.resolve(type(of: route).dependencyKey)?.closure(route,source)
    }
}
