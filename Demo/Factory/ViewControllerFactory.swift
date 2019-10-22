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

class DefaultViewControllerFactory: ViewControllerFactory {
    func viewController(from itemIdentifier: ItemIdentifier) -> UIViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "vc")
    }
    func viewController(with viewModel: ItemViewModel) -> UIViewController? {
        let viewController = self.viewController(from: viewModel.itemIdentifier)
        (viewController as? WithItemViewModel)?.configure(with: viewModel)
        return viewController
    }
}
