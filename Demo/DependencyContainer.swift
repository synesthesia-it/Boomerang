//
//  DependencyContainer.swift
//  NewArch
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

protocol AppDependencyContainer  {
    var routeFactory: RouteFactory { get }
    var viewFactory: ViewFactory { get }
    var collectionViewCellFactory: CollectionViewCellFactory { get }
    var viewControllerFactory: ViewControllerFactory { get }
}

enum DependencyContainerKeys: CaseIterable, Hashable {
    case routeFactory
    case collectionViewCellFactory
    case viewFactory
    case viewControllerFactory
}


class DefaultAppDependencyContainer: AppDependencyContainer, DependencyContainer {
    typealias Key = DependencyContainerKeys
    
    var container: [Key: () -> Any ] = [:]
    
    var routeFactory: RouteFactory { self[.routeFactory] }
    var viewFactory: ViewFactory { self[.viewFactory] }
    var viewControllerFactory: ViewControllerFactory { self[.viewControllerFactory] }
    var collectionViewCellFactory: CollectionViewCellFactory { self[.collectionViewCellFactory] }
    
    init() {
        self.register(for: .routeFactory) { MainRouteFactory(container: self) }
        self.register(for: .viewFactory) { MainViewFactory()}
        self.register(for: .collectionViewCellFactory) { MainCollectionViewCellFactory(viewFactory: self.viewFactory) }
        self.register(for: .viewControllerFactory) { DefaultViewControllerFactory(container: self) }
    }
    
    subscript<T>(index: Key) -> T {
        guard let element: T = resolve(index) else {
            fatalError("No dependency found for \(index)")
        }
        return element
    }
}

///Convert in Test, this is temporary
extension DefaultAppDependencyContainer {
    func testAll() {
        
        DependencyContainerKeys.allCases.forEach {
            //expect no throw
            let v: Any = self[$0]
            print(v)
            
        }
    }
}

