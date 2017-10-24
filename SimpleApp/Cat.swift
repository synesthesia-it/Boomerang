//
//  Cat.swift
//  SimpleApp
//
//  Created by Stefano Mondino on 23/10/17.
//

import Foundation
import Boomerang

enum Cat : String, ModelType {
    case ragdoll = "ragdoll"
    case persian = "persian"
    case european = "european"
    case maineCoon = "maineCoon"
    case random = "random"
    static var all: [Cat] {
        return [.random, .persian, .european, .maineCoon, .ragdoll]
    }
    var image:URL {
        return URL(string:"http://lorempixel.com/400/200/cats?\(self.rawValue)")!
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


