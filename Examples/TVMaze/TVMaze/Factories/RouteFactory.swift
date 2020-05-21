//
//  RouteFactory.swift
//  TVMaze
//
//  Created by Stefano Mondino on 21/05/2020.
//  Copyright © 2020 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
import Boomerang

protocol RouteFactory {
    func restartRoute() -> Route
}

struct DeviceRouteFactory: RouteFactory {
    let container: AppDependencyContainer
    
    func restartRoute() -> Route {
        return RestartRoute {
            self.container.sceneFactory.root()
        }
    }
}
