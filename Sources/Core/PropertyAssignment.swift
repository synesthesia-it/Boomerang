//
//  PropertyAssignment.swift
//  Boomerang
//
//  Created by Stefano Mondino on 11/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public protocol WithPropertyAssignment: AnyObject {}

extension NSObject: WithPropertyAssignment {}

public extension WithPropertyAssignment {

    func with<T>(_ keyPath: ReferenceWritableKeyPath<Self, T>, to value: T) -> Self {
        self[keyPath: keyPath] = value
        return self
    }
    func updating<T>(_ keyPath: ReferenceWritableKeyPath<Self, T>, with value: T) -> Self {
        self.with(keyPath, to: value)
    }
}
