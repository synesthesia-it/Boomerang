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
    var className: AnyClass? { get }
}

public protocol ViewIdentifier: ReusableListIdentifier {
    func view<T: View>() -> T?
}


