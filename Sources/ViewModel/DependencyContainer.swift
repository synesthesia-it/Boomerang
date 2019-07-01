//
//  DependencyContainer.swift
//  Alamofire
//
//  Created by Stefano Mondino on 07/02/2019.
//

import Foundation

public protocol DependencyContainer {
//    associatedtype Key: DependencyKey
    associatedtype Value
    static var container: Container<DependencyKey.KeyType,Value> { get set }
//    static func register(_ key: DependencyKey, handler: @escaping () -> Value)
//    static func resolve(_ key: DependencyKey) -> Value?
}

public protocol DependencyKey {
    typealias KeyType = Int
    var dependencyKey: KeyType { get }
//    static var dependencyKey: KeyType { get }
}

public extension DependencyKey where Self: Hashable {
    var dependencyKey: DependencyKey.KeyType { return hashValue }
}
public extension DependencyKey {
    static var dependencyKey: DependencyKey.KeyType {
        return ObjectIdentifier(self).hashValue
    }
}

extension DependencyContainer {
    public static func register<T: DependencyKey>(_ key: T, handler: @escaping () -> Value) {
        container.register(for: key.dependencyKey, handler: handler)
    }
    public static func resolve(_ key: DependencyKey) -> Value? {
        return container.resolve(key.dependencyKey)
    }
    
    public static func register<T: DependencyKey>(_ key: T.Type, handler: @escaping () -> Value) {
        container.register(for: key.dependencyKey, handler: handler)
    }
    public static func resolve(_ key: DependencyKey.Type) -> Value? {
        return container.resolve(key.dependencyKey)
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
