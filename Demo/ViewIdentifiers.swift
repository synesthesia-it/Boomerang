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

typealias Image = UIImage

struct Identifiers {
    enum SupplementaryTypes {
        case header
        case footer
        
        var name: String {
            switch self {
            case .header: return UICollectionView.elementKindSectionHeader
            case .footer: return UICollectionView.elementKindSectionFooter
            }
        }
    }
    
    enum Scenes: String, SceneIdentifier {
        func scene<T>() -> T? where T : Scene {
            return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: self.name) as? T
        }
    
        var name: String {
            return rawValue
        }
        
        case schedule
    }
    
    enum Views: String, ViewIdentifier {
        
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
