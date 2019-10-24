//
//  ViewFactory.swift
//  Demo
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit
import Boomerang

enum ViewIdentifier: String, ItemIdentifier {
    case show
    
    var identifierString: String {
        return self.rawValue
    }
}

class MainViewFactory: ViewFactory {
    func view(from itemIdentifier: ItemIdentifier) -> UIView? {
        return nib(from: itemIdentifier)?
        .instantiate(withOwner: nil, options: nil)
        .first as? UIView
    }
    
    func nib(from itemIdentifier: ItemIdentifier) -> UINib? {
        return UINib(nibName: name(from: itemIdentifier), bundle: nil)
    }
    
    func name(from itemIdentifier: ItemIdentifier) -> String {
        let id = itemIdentifier.identifierString
        
        return id.prefix(1).uppercased() + id.dropFirst() + "ItemView"
    }
}

