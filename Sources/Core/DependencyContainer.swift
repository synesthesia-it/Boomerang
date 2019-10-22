//
//  DependencyContainer.swift
//  Alamofire
//
//  Created by Stefano Mondino on 07/02/2019.
//

import Foundation

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
