//
//  InitializationRoot.swift
//  TVMaze
//
//  Created by Stefano Mondino on 21/05/2020.
//  Copyright © 2020 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

protocol AppDependencyContainer {
    var routeFactory: RouteFactory { get }
//    var viewFactory: ViewFactory { get }
//    var collectionViewCellFactory: CollectionViewCellFactory { get }
//    var viewControllerFactory: ViewControllerFactory { get }
    var sceneFactory: SceneFactory { get }
    var viewModels: ViewModelFactory { get }
//    var itemViewModelFactory: ItemViewModelFactory { get }
}

class InitializationRoot: AppDependencyContainer, DependencyContainer {
    enum Keys: CaseIterable, Hashable {
        case routeFactory
        case sceneFactory
        case viewModels
    }
    let container = Container<Keys>()

    var routeFactory: RouteFactory { self[.routeFactory] }
    var sceneFactory: SceneFactory { self[.sceneFactory] }
    var viewModels: ViewModelFactory { self [.viewModels] }

    init() {
        self.register(for: .routeFactory) { DeviceRouteFactory(container: self) }
        self.register(for: .sceneFactory) { ViewControllerFactory(container: self) }
        self.register(for: .viewModels) { AppViewModelFactory(container: self) }
    }
}
