//
//  DependencyContainer.swift
//  Boomerang
//
//  Created by Stefano Mondino on 08/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public protocol DependencyContainer: AnyObject {
    associatedtype Key: Hashable
    var container: [Key: () -> Any ] { get set }
}

public extension DependencyContainer {
    
    func register<Value: Any>(for key: Key, handler: @escaping () -> Value) {
        container[key] = handler
    }
    
    func resolve<Value: Any>(_ key: Key) -> Value? {
        return container[key]?() as? Value 
    }
}

