//
//  ViewControllerFactory.swift
//  Demo
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import SwiftUI
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
//
// class MainViewControllerFactory: ViewControllerFactory {
//    
//    func name(from itemIdentifier: LayoutIdentifier) -> String {
//        let id = itemIdentifier.identifierString
//        return id.prefix(1).uppercased() + id.dropFirst() + "Scene"
//        
//    }
//    func `class`(from itemIdentifier: LayoutIdentifier) -> UIViewController.Type? {
//        guard let info = Bundle.main.infoDictionary,
//            let bundleName = info["CFBundleExecutable"] as? String else { return nil }
//        let className = name(from: itemIdentifier)
//        return Bundle.main.classNamed([bundleName, className].joined(separator: ".")) as? UIViewController.Type
//    }
//    func viewController(from itemIdentifier: LayoutIdentifier) -> UIViewController? {
//        
//        guard let viewControllerClass = `class`(from: itemIdentifier) else { return nil }
//        
//        return viewControllerClass.init(nibName: name(from: itemIdentifier), bundle: nil)
//    }
//    
//    func viewController(with viewModel: ViewModel) -> UIViewController? {
//        let viewController = self.viewController(from: viewModel.layoutIdentifier)
//        (viewController as? WithViewModel)?.configure(with: viewModel)
//        return viewController
//    }
// }
