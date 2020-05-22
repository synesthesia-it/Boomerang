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
    func showsRoute() -> Route
    func sideMenu(from menu: MenuItem) -> Route
}

struct DeviceRouteFactory: RouteFactory {
    let container: AppDependencyContainer
    
    func restartRoute() -> Route {
        return RestartRoute {
            self.container.sceneFactory.root()
        }
    }
    func showsRoute() -> Route {
        return ModalRoute {
            self.container.sceneFactory.show()
        }
    }
    func sideMenu(from menu: MenuItem) -> Route {
        SideMenuRoute {
            var scene: Scene?
            switch menu {
            case .schedule: scene = self.container.sceneFactory.show()
            case .search: scene = self.container.sceneFactory.search()
            }
            let item = UIBarButtonItem(title: "Menu", style: .done, target: scene, action: #selector(Scene.showMenu))
            scene?.navigationItem.leftBarButtonItem = item
            return scene?.embedded()
        }
    }
}

extension Scene {
    func embedded() -> Scene {
        let navigation = UINavigationController(rootViewController: self)
        navigation.navigationBar.prefersLargeTitles = true
        return navigation
    }
    @objc func showMenu() {
        pax.showMenu(at: .left)
    }
}
