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
    func restart() -> Route
    func credits(for person: Person) -> Route
    func sideMenu(from menu: MenuItem) -> Route
    func detail(for item: WithShow) -> Route
}

struct DeviceRouteFactory: RouteFactory {
    let container: AppDependencyContainer
    
    func restart() -> Route {
        return RestartRoute {
            self.container.sceneFactory.root()
        }
    }
    func credits(for person: Person) -> Route {
        return NavigationRoute {
            self.container.sceneFactory.credits(for: person)
        }
    }

    func detail(for item: WithShow) -> Route {
        return NavigationRoute {
            self.container.sceneFactory.showDetail(for: item)
        }
    }

    func sideMenu(from menu: MenuItem) -> Route {
        SideMenuRoute {
            var scene: Scene?
            switch menu {
            case .schedule: scene = self.container.sceneFactory.schedule()
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
