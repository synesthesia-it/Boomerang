//
//  PropertyAssignment.swift
//  Boomerang
//
//  Created by Stefano Mondino on 11/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

/** An object with extensions to quickly change inner properties in a quick "builder" way
Examples:
 ```
    let view = UIView().with(\.backgroundColor,
                             to: .clear)
 
    let label = UILabel().with {
                    $0.textColor = .red
                    $0.text = "ciao"
            }
 ```
 **/
public protocol WithPropertyAssignment {}

public extension WithPropertyAssignment {
    /// Updates property with specific keypath to selected value
    mutating func with<T>(_ keyPath: WritableKeyPath<Self, T>, to value: T) -> Self {
        self[keyPath: keyPath] = value
        return self
    }
    /// Alias for `with(_, to:)`
    mutating func updating<T>(_ keyPath: WritableKeyPath<Self, T>, with value: T) -> Self {
        self.with(keyPath, to: value)
    }
    /// Modifies source object with specified closure
    mutating func with(_ closure: @escaping (inout Self) -> Void) -> Self {
        closure(&self)
        return self
    }
}

public extension WithPropertyAssignment where Self: AnyObject {
    /// Updates property with specific keypath to selected value
    func with<T>(_ keyPath: ReferenceWritableKeyPath<Self, T>, to value: T) -> Self {
        self[keyPath: keyPath] = value
        return self
    }
    /// Alias for `with(_, to:)`
    func updating<T>(_ keyPath: ReferenceWritableKeyPath<Self, T>, with value: T) -> Self {
        self.with(keyPath, to: value)
    }
    /// Modifies source object with specified closure
    func with(_ closure: @escaping (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}

extension NSObject: WithPropertyAssignment {}
