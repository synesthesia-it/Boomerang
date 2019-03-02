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
    enum SupplementaryTypes: String {
        case header
        case footer
        
        var name: String {
            return rawValue
        }
    }
    enum Scenes: String, SceneIdentifier {
        func scene<T>() -> T? where T : Scene {
            return nil
//            return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: self.name) as? T
        }
        
        var name: String {
            return rawValue
        }
        
        case schedule
        case showDetail
        case scheduleStacked
    }
    enum Views: String, ViewIdentifier {
        
        case show
        case header
        
        func view<T>() -> T? where T : View {
            return nil
//            return Bundle.main.loadNibNamed(self.name, owner: nil, options: nil)?.first as? T
        }
        
        var shouldBeEmbedded: Bool { return true }
        
        var className: AnyClass? { return nil }
        var containerClass: AnyClass? { return nil }
        var name: String {
            
            return rawValue.firstCharacterCapitalized() + "RowController"
        }
        
    }
}
