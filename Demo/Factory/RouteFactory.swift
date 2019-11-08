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
    init(viewModel: ShowDetailViewModel) {
        self.createScene = {
            ShowDetailViewController(nibName: "ShowDetailViewController", viewModel: viewModel)
        }
    }
    init(viewModel: ScheduleViewModel) {
        self.createScene = {
            ScheduleViewController(nibName: "ScheduleViewController", viewModel: viewModel)
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
    private let routeFactory: RouteFactory
    func execute(from scene: Scene?) {
        let classic = ScheduleViewController(nibName: "ScheduleViewController", viewModel: ScheduleViewModel(routeFactory: routeFactory))
        let rx = ScheduleViewController(nibName: "ScheduleViewController", viewModel: RxScheduleViewModel(routeFactory: routeFactory))
        classic?.tabBarItem.title = "Schedule"
        rx?.tabBarItem.title = "RxSchedule"
        let viewControllers = [classic, rx].compactMap { $0 }
       
        let root = UITabBarController()
        root.viewControllers = viewControllers
               //TODO Dismiss all modals
        UIApplication.shared.delegate?.window??.rootViewController = root
        UIApplication.shared.delegate?.window??.makeKeyAndVisible()
    }
    
    init(routeFactory: RouteFactory) {
        self.routeFactory = routeFactory
    }
}

protocol RouteFactory {
    var container: DependencyContainer { get }
    func restartRoute() -> Route
    func detailRoute(show: Show) -> Route
}
class MainRouteFactory: RouteFactory {
    let container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
    }
    
    func restartRoute() -> Route {
        RestartRoute(routeFactory: container.routeFactory)
    }
    
    func detailRoute(show: Show) -> Route {
        //return AlertRoute(viewModel: ShowDetailViewModel(show: show))
        return ModalRoute(viewModel: ShowDetailViewModel(show: show))
        //return ModalRoute(viewModel: ScheduleViewModel())
    }
}
