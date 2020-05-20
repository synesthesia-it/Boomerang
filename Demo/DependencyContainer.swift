//
//  DependencyContainer.swift
//  NewArch
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import UIKitBoomerang
protocol AppDependencyContainer {
    var routeFactory: RouteFactory { get }
    var viewFactory: ViewFactory { get }
    var collectionViewCellFactory: CollectionViewCellFactory { get }
    var tableViewCellFactory: TableViewCellFactory { get }
    var viewControllerFactory: ViewControllerFactory { get }
    var sceneViewModelFactory: SceneViewModelFactory { get }
    var itemViewModelFactory: ItemViewModelFactory { get }
}

enum DependencyContainerKeys: CaseIterable, Hashable {
    case routeFactory
    case collectionViewCellFactory
    case tableViewCellFactory
    case viewFactory
    case viewControllerFactory
    case sceneViewModelFactory
    case itemViewModelFactory
}

class DefaultAppDependencyContainer: AppDependencyContainer, DependencyContainer {

    var container = Container<DependencyContainerKeys>()

    var routeFactory: RouteFactory { self[.routeFactory] }
    var viewFactory: ViewFactory { self[.viewFactory] }
    var viewControllerFactory: ViewControllerFactory { self[.viewControllerFactory] }
    var collectionViewCellFactory: CollectionViewCellFactory { self[.collectionViewCellFactory] }
    var tableViewCellFactory: TableViewCellFactory { self[.tableViewCellFactory] }
    var sceneViewModelFactory: SceneViewModelFactory { self[.sceneViewModelFactory] }
    var itemViewModelFactory: ItemViewModelFactory { self[.itemViewModelFactory] }
    
    init() {
        self.register(for: .routeFactory) { MainRouteFactory(container: self) }
        self.register(for: .viewFactory) { MainViewFactory()}
        self.register(for: .collectionViewCellFactory) { MainCollectionViewCellFactory(viewFactory: self.viewFactory) }
        self.register(for: .tableViewCellFactory) { MainTableViewCellFactory(viewFactory: self.viewFactory) }
        self.register(for: .viewControllerFactory) { DefaultViewControllerFactory(container: self) }
        self.register(for: .sceneViewModelFactory) { DefaultSceneViewModelFactory(container: self) }
        self.register(for: .itemViewModelFactory) { DefaultItemViewModelFactory(container: self) }
    }
}

///Convert in Test, this is temporary
extension DefaultAppDependencyContainer {
    func testAll() {

        DependencyContainerKeys.allCases.forEach {
            //expect no throw
            let value: Any = self[$0]
            print(value)

        }
    }
}
