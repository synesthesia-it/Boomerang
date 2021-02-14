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
    case tableSchedule
    case showDetail
    case loremIpsum

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
    func loremIpsum(viewModel: LoremIpsumViewModel) -> UIViewController {
        return LoremIpsumViewController(nibName: name(from: viewModel.layoutIdentifier),
                                      viewModel: viewModel,
                                      collectionViewCellFactory: container.collectionViewCellFactory)
    }
    func tableSchedule(viewModel: ListViewModel & NavigationViewModel) -> UIViewController {
        return TableScheduleViewController(nibName: name(from: viewModel.layoutIdentifier),
                                      viewModel: viewModel,
                                      tableViewCellFactory: container.tableViewCellFactory)
    }


    func showDetail(viewModel: ShowDetailViewModel) -> UIViewController {
        return ShowDetailViewController(nibName: name(from: viewModel.layoutIdentifier),
                                        viewModel: viewModel,
                                        collectionViewCellFactory: container.collectionViewCellFactory)
    }

    func root() -> UIViewController {
        let classic = self.schedule(viewModel: container.sceneViewModelFactory.schedule())
        let table = self.tableSchedule(viewModel: container.sceneViewModelFactory.tableSchedule())
        let lorem = self.loremIpsum(viewModel: container.sceneViewModelFactory.loremIpsum())
        let viewModelFactory = container.itemViewModelFactory
        let reactive = self.schedule(viewModel: RxScheduleViewModel(itemViewModelFactory: viewModelFactory,
                                                                    routeFactory: container.routeFactory))

        classic.tabBarItem.title = "Schedule"
        table.tabBarItem.title = "Table"
        reactive.tabBarItem.title = "RxSchedule"
        lorem.tabBarItem.title = "Lorem"
        let viewControllers = [classic, table, reactive, lorem].compactMap { $0 }

        let root = UITabBarController()
        root.viewControllers = viewControllers
        return root
    }

}
