//
//  ViewModelFactory.swift
//  Demo
//
//  Created by Stefano Mondino on 20/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

protocol SceneViewModelFactory {
    func schedule() -> ListViewModel & NavigationViewModel
    func showDetail(show: Show) -> ShowDetailViewModel
    func todo() -> ListViewModel & NavigationViewModel
}

struct DefaultSceneViewModelFactory: SceneViewModelFactory {

    let container: AppDependencyContainer

    func schedule() -> ListViewModel & NavigationViewModel {
        return ScheduleViewModel(itemViewModelFactory: container.itemViewModelFactory,
                                 routeFactory: container.routeFactory)
    }
    func showDetail(show: Show) -> ShowDetailViewModel {
        return ShowDetailViewModel(show: show)
    }
    
    func todo() -> ListViewModel & NavigationViewModel {
        return TodosViewModel(itemViewModelFactory: container.itemViewModelFactory, routeFactory: container.routeFactory)
    }
}
