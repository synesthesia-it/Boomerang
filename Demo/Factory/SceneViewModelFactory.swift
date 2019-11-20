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
    func scheduleViewModel() -> ViewModel
    func showDetail(show: Show) -> ViewModel
}

struct DefaultSceneViewModelFactory: SceneViewModelFactory {
    
    let container: AppDependencyContainer
    
    func scheduleViewModel() -> ViewModel {
        return ScheduleViewModel(itemViewModelFactory: container.itemViewModelFactory, routeFactory: container.routeFactory)
    }
    func showDetail(show: Show) -> ViewModel {
        return ShowDetailViewModel(show: show)
    }
}
