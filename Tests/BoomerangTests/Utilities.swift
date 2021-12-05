//
//  File.swift
//  
//
//  Created by Stefano Mondino on 05/12/21.
//

import Foundation
import Boomerang

extension String: LayoutIdentifier {
    public var identifierString: String { self }
}

class TestItemViewModel: ViewModel {
    var uniqueIdentifier: UniqueIdentifier = UUID()
    var layoutIdentifier: LayoutIdentifier = UUID().stringValue
    let string: String
    init(_ string: String) {
        self.string = string
    }
}

struct FakeRoute: Route {
    var createScene: () -> Scene? = { nil }
    func execute<T>(from scene: T?) where T : Scene { }
}
