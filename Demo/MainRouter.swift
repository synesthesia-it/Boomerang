//
//  MainRouter.swift
//  Demo
//
//  Created by Stefano Mondino on 24/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import UIKit

class MainRouter: Router {
    private let factory: ViewControllerFactory
    init(factory: ViewControllerFactory = MainViewControllerFactory()) {
        self.factory = factory
    }
    public func execute(_ route: Route, from source: Scene?) {
        switch route {
        case let route as NavigationRoute:
            if let viewController = factory.viewController(from: route.viewModel.layoutIdentifier) as? UIViewController & WithViewModel,
                let source = source
            {
                viewController.configure(with: route.viewModel)
                if let navigation = source.navigationController {
                    self.push(viewController: viewController, from: navigation)
                } else {
                    self.present(viewController: viewController, from: source)
                }
            }
            
            
        default: break
        }
    }
    
    private func push(viewController: UIViewController, from navigationController: UINavigationController) {
        navigationController.pushViewController(viewController, animated: true)
    }
    private func present(viewController: UIViewController, from source: UIViewController, animated: Bool = true) {
        source.present(viewController, animated: animated, completion: nil)
    }
    func restart() {
        
        let viewControllers = [ScheduleViewModel(), RxScheduleViewModel()]
            .compactMap { (viewModel: ViewModel) -> UIViewController? in
                let root = factory.viewController(from: viewModel.layoutIdentifier)
                (root as? WithViewModel)?.configure(with: viewModel)
                return root
        }
        let root = UITabBarController()
        zip(["Schedule", "RxSchedule"], viewControllers).forEach {
            $1.tabBarItem.title = $0
        }
        root.viewControllers = viewControllers
        //TODO Dismiss all modals
        UIApplication.shared.delegate?.window??.rootViewController = root
        UIApplication.shared.delegate?.window??.makeKeyAndVisible()
    }
}
