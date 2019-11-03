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

class MainViewControllerFactory: ViewControllerFactory {

    func name(from itemIdentifier: LayoutIdentifier) -> String {
        let identifier = itemIdentifier.identifierString
        return identifier.prefix(1).uppercased() + identifier.dropFirst() + "ViewController"

    }
    func `class`(from itemIdentifier: LayoutIdentifier) -> UIViewController.Type? {
        guard let info = Bundle.main.infoDictionary,
            let bundleName = info["CFBundleExecutable"] as? String else { return nil }
        let className = name(from: itemIdentifier)
        return Bundle.main.classNamed([bundleName, className].joined(separator: ".")) as? UIViewController.Type
    }
    func viewController(from itemIdentifier: LayoutIdentifier) -> (UIViewController & WithViewModel)? {

        guard let type = `class`(from: itemIdentifier) else { return nil }

        return type.init(nibName: name(from: itemIdentifier), bundle: nil) as? (UIViewController & WithViewModel)
    }

    func viewController(with viewModel: ViewModel) -> (UIViewController & WithViewModel)? {
        guard let viewController = self.viewController(from: viewModel.layoutIdentifier)  else {
            return nil
        }
        viewController.configure(with: viewModel)
        return viewController
    }
}
