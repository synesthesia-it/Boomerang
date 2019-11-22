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
        return RestartRoute {
            self.container.viewControllerFactory.root()
        }
    }

    func detailRoute(show: Show) -> Route {
        return ModalRoute { self.container
            .viewControllerFactory
            .showDetail(viewModel: ShowDetailViewModel(show: show))
        }
        //return ModalRoute(viewModel: ScheduleViewModel())
    }
}
