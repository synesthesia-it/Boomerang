//
//  Cat.swift
//  SimpleApp
//
//  Created by Stefano Mondino on 23/10/17.
//

import Foundation
import Boomerang

enum Cat : ModelType {
    case ragdoll
    case persian
    case european
    case maineCoon
    case random
    static var all: [Cat] {
        return [.random, .persian, .european, .maineCoon, .ragdoll]
    }
    var title : String {
        switch self {
        case .ragdoll : return "Ragdoll"
        case .persian : return "Persian"
        case .european : return "European"
        case .maineCoon : return "Maine Coon"
        case .random  : return "Random cat"
        }
    }
}
