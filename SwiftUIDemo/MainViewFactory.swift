//
//  ViewFactory.swift
//  Demo
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit
import Boomerang

enum ViewIdentifier: String, LayoutIdentifier {
    case show
    
    var identifierString: String {
        return self.rawValue
    }
}

//class MainViewFactory: ViewFactory {
//    func view(from itemIdentifier: LayoutIdentifier) -> UIView? {
//        return nib(from: itemIdentifier)?
//        .instantiate(withOwner: nil, options: nil)
//        .first as? UIView
//    }
//    
//    func nib(from itemIdentifier: LayoutIdentifier) -> UINib? {
//        return UINib(nibName: name(from: itemIdentifier), bundle: nil)
//    }
//    
//    func name(from itemIdentifier: LayoutIdentifier) -> String {
//        let id = itemIdentifier.identifierString
//        
//        return id.prefix(1).uppercased() + id.dropFirst() + "ItemView"
//    }
//}

