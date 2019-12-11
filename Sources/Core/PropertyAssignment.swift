//
//  PropertyAssignment.swift
//  Demo
//
//  Created by Stefano Mondino on 11/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public protocol WithPropertyAssignment: AnyObject {}

extension NSObject: WithPropertyAssignment {}

public extension WithPropertyAssignment {
    func with<T>(_ value: T, to keyPath: WritableKeyPath<Self, T>) -> Self {
        var obj = self
        obj[keyPath: keyPath] = value
        return obj
    }
}
