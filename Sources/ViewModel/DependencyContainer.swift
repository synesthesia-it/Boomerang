//
//  DependencyContainer.swift
//  Alamofire
//
//  Created by Stefano Mondino on 07/02/2019.
//

import Foundation

public protocol DependencyContainer {
    associatedtype Key: DependencyKey
    associatedtype Value
    static var container: Container<String,Value> { get set }
    static func register(for key: Key, handler: @escaping () -> Value)
    static func resolve(_ key: Key) -> Value?
}

public protocol DependencyKey {
    var keyValue: String { get }
}

extension String: DependencyKey {
    public var keyValue: String { return self }
}
extension DependencyContainer {
    public static func register(for key: Key, handler: @escaping () -> Value) {
        container.register(for: key.keyValue, handler: handler)
    }
    public static func resolve(_ key: Key) -> Value? {
        return container.resolve(key.keyValue)
    }
}

public struct Container<Key: Hashable, Value> {
    private var container: [Key: () -> Value ] = [:]
    public init() {}
    mutating func register(for key: Key, handler: @escaping () -> Value) {
        container[key] = handler
    }
    
    func resolve(_ key: Key) -> Value? {
        return container[key]?()
    }
}
