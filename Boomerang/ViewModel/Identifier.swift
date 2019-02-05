//
//  Identifier.swift
//  Boomerang
//
//  Created by Stefano Mondino on 27/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public protocol Identifier {
    var name: String { get }
}
public protocol ReusableListIdentifier: Identifier {
    var shouldBeEmbedded: Bool { get }
    var containerClass: AnyClass? { get }
    var `class`: AnyClass? { get }
}
public extension ReusableListIdentifier {
    var `class`: AnyClass? { return nil }
}
public protocol ViewIdentifier: ReusableListIdentifier {
    func view<T: View>() -> T?
}




