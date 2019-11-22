//
//  DependencyContainer.swift
//  Boomerang
//
//  Created by Stefano Mondino on 08/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public protocol DependencyContainer: AnyObject {
    associatedtype DependencyKey: Hashable
    var container: Container<DependencyKey> { get }
}
public class Container<DependencyKey: Hashable> {

    struct Dependency {
        let scope: Scope
        let closure: () -> Any
    }

    public enum Scope {
        case unique
        case singleton
    }

    fileprivate var dependencies: [DependencyKey: Dependency] = [:]
    fileprivate var singletons: [DependencyKey: Any] = [:]

    public init() {}
}
public extension DependencyContainer {

    func register<Value: Any>(for key: DependencyKey, scope: Container<DependencyKey>.Scope = .unique, handler: @escaping () -> Value) {
        container.singletons[key] = nil
        container.dependencies[key] = Container<DependencyKey>.Dependency(scope: scope, closure: handler)
    }

    func resolve<Value: Any>(_ key: DependencyKey) -> Value? {
        guard let dependency = container.dependencies[key] else { return nil }
        switch dependency.scope {
        case .unique: return dependency.closure() as? Value
        case .singleton: guard let value = container.singletons[key] else {
            let newValue = dependency.closure()
            container.singletons[key] = newValue
            return newValue as? Value
        }
        return value as? Value
        }
    }
}
public extension DependencyContainer {
    subscript<T>(index: DependencyKey) -> T {
        guard let element: T = resolve(index) else {
            fatalError("No dependency found for \(index)")
        }
        return element
    }
}
