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

enum SceneIdentifier: String, ItemIdentifier {
    case main
    
    var identifierString: String {
        switch self {
            case .main: return "vc"
        }
    }
}

class DefaultViewControllerFactory: ViewControllerFactory {
    func viewController(from itemIdentifier: ItemIdentifier) -> UIViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: itemIdentifier.identifierString)
    }
    func viewController(with viewModel: ItemViewModel) -> UIViewController? {
        let viewController = self.viewController(from: viewModel.itemIdentifier)
        (viewController as? WithItemViewModel)?.configure(with: viewModel)
        return viewController
    }
}
