//
//  ViewControllerFactory.swift
//  Demo
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
import Boomerang

enum SceneIdentifier: String, LayoutIdentifier {
    case schedule
    case showDetail
    
    var identifierString: String {
        switch self {
        default: return rawValue
        }
    }
}

protocol ViewControllerFactory {
    func root() -> UIViewController
    func schedule(viewModel: ListViewModel & NavigationViewModel) -> UIViewController
    func showDetail(viewModel: ShowDetailViewModel) -> UIViewController
}

class DefaultViewControllerFactory: ViewControllerFactory {
    let container: AppDependencyContainer
    
    init(container: AppDependencyContainer) {
        self.container = container
    }
    
    private func name(from layoutIdentifier: LayoutIdentifier) -> String {
        let identifier = layoutIdentifier.identifierString
        return identifier.prefix(1).uppercased() + identifier.dropFirst() + "ViewController"
    }
    
    func schedule(viewModel: ListViewModel & NavigationViewModel) -> UIViewController {
        return ScheduleViewController(nibName: name(from: viewModel.layoutIdentifier),
                                      viewModel: viewModel,
                                      collectionViewCellFactory: container.collectionViewCellFactory)
    }
    
    func showDetail(viewModel: ShowDetailViewModel) -> UIViewController {
        return ShowDetailViewController(nibName: name(from: viewModel.layoutIdentifier),
                                        viewModel: viewModel,
                                        collectionViewCellFactory: container.collectionViewCellFactory)
    }
    
    func root() -> UIViewController {
        let classic = self.schedule(viewModel: ScheduleViewModel(itemViewModelFactory: container.itemViewModelFactory, routeFactory: container.routeFactory))
        let rx = self.schedule(viewModel: RxScheduleViewModel(routeFactory: container.routeFactory))
        
        classic.tabBarItem.title = "Schedule"
        rx.tabBarItem.title = "RxSchedule"
        let viewControllers = [classic, rx].compactMap { $0 }
        
        let root = UITabBarController()
        root.viewControllers = viewControllers
        return root
    }
    
}
