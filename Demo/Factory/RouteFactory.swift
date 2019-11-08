//
//  RouteFactory.swift
//  Demo
//
//  Created by Stefano Mondino on 07/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import UIKit

struct ModalRoute: Route {
    let createScene: () -> Scene?
    init(viewModel: ShowDetailViewModel,
         factory: ViewControllerFactory) {
        self.createScene = {
            factory.showDetail(viewModel: viewModel)
        }
    }
    init(viewModel: ScheduleViewModel,
         factory: ViewControllerFactory) {
        self.createScene = {
            factory.schedule(viewModel: viewModel)
        }
    }
}

struct AlertRoute: Route {
    var title: String
    init(viewModel: ShowDetailViewModel) {
        self.title = viewModel.title
    }
    func execute(from scene: Scene?) {
        let destination = UIAlertController(title: title, message: "CIAO", preferredStyle: .actionSheet)
        scene?.present(destination, animated: true, completion: nil)
    }
}

extension ModalRoute {
    func execute(from scene: Scene?) {
        if let destination = createScene() {
            scene?.present(destination, animated: true, completion: nil)
        }
    }
}

struct RestartRoute: Route {
//    private let routeFactory: RouteFactory
    let createScene: () -> Scene?
    func execute(from scene: Scene?) {
       
               //TODO Dismiss all modals
        UIApplication.shared.delegate?.window??.rootViewController = createScene()
        UIApplication.shared.delegate?.window??.makeKeyAndVisible()
    }
    
     init(viewModel: ScheduleViewModel,
            factory: ViewControllerFactory) {
        
        self.createScene = {
            
            return factory.schedule(viewModel: viewModel)
            
//            let classic = ScheduleViewController(nibName: "ScheduleViewController",
//                                                        viewModel: ScheduleViewModel(routeFactory: routeFactory),
//                                                        collectionViewCellFactory: routeFactory.container.collectionViewCellFactory)
//                   let rx = ScheduleViewController(nibName: "ScheduleViewController",
//                                                   viewModel: RxScheduleViewModel(routeFactory: routeFactory),
//                                                   collectionViewCellFactory: routeFactory.container.collectionViewCellFactory)
//                   classic.tabBarItem.title = "Schedule"
//                   rx.tabBarItem.title = "RxSchedule"
//                   let viewControllers = [classic, rx].compactMap { $0 }
                  
//                   let root = UITabBarController()
//                   root.viewControllers = viewControllers
        }
    }
}

protocol RouteFactory {
    var container: AppDependencyContainer { get }
    func restartRoute() -> Route
    func detailRoute(show: Show) -> Route
}
class MainRouteFactory: RouteFactory {
    let container: AppDependencyContainer
    
    init(container: AppDependencyContainer) {
        self.container = container
    }
    
    func restartRoute() -> Route {
        return RestartRoute(viewModel: ScheduleViewModel(routeFactory: self), factory: container.viewControllerFactory)
    }
    
    func detailRoute(show: Show) -> Route {
        //return AlertRoute(viewModel: ShowDetailViewModel(show: show))
        return ModalRoute(viewModel: ShowDetailViewModel(show: show), factory: container.viewControllerFactory)
        //return ModalRoute(viewModel: ScheduleViewModel())
    }
}


protocol ViewControllerFactory {
    func schedule(viewModel: ScheduleViewModel) -> UIViewController
    func showDetail(viewModel: ShowDetailViewModel) -> UIViewController
}

class DefaultViewControllerFactory: ViewControllerFactory {
    let container: AppDependencyContainer
    init(container: AppDependencyContainer) {
        self.container = container
    }
    func schedule(viewModel: ScheduleViewModel) -> UIViewController {
        return ScheduleViewController(nibName: "ScheduleViewController",
        viewModel: viewModel,
        collectionViewCellFactory: container.collectionViewCellFactory)
    }
    
    func showDetail(viewModel: ShowDetailViewModel) -> UIViewController {
        return ShowDetailViewController(nibName: "ShowDetailViewController",
        viewModel: viewModel,
        collectionViewCellFactory: container.collectionViewCellFactory)
    }
}
