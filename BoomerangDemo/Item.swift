//
//  Item.swift
//  Boomerang
//
//  Created by Stefano Mondino on 13/11/16.
//
//

import Foundation
import Boomerang

struct Item : ModelType {
    public var title: String? {get {return self.string}}
    
    var string:String
}


struct Section : ModelType {
    public var title: String? {get {return self.string}}
    
    var string:String
}
