//
//  ViewIdentifiers.swift
//  Demo
//
//  Created by Stefano Mondino on 27/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import UIKit

struct Identifiers {
    enum View: String, ViewIdentifier {
        
        case show
        case header
        
        func view<T>() -> T? where T : UIView {
            return Bundle.main.loadNibNamed(self.name, owner: nil, options: nil)?.first as? T
        }
        
        var shouldBeEmbedded: Bool { return true }
        
        var className: AnyClass? { return nil }
        
        var name: String {
            var suffix = ""
            if UIDevice.current.userInterfaceIdiom == .tv {
                suffix = "~tv"
            }
            
            return rawValue.firstCharacterCapitalized() + "ItemView" + suffix
        }
        
    }
}
