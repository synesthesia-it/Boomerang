//
//  ViewControllerFactory.swift
//  Demo
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
import Boomerang

enum SceneIdentifier: String, LayoutIdentifier {
    case schedule
    case showDetail

    var identifierString: String {
        switch self {
        default: return rawValue
        }
    }
}

class MainViewControllerFactory {

    func name(from layoutIdentifier: LayoutIdentifier) -> String {
        let identifier = layoutIdentifier.identifierString
        return identifier.prefix(1).uppercased() + identifier.dropFirst() + "ViewController"
    }
    
    func viewController<ViewController: UIViewController>(with layoutIdentifier: LayoutIdentifier) -> ViewController? {
        return ViewController(nibName: name(from: layoutIdentifier), bundle: nil)
    }
}
