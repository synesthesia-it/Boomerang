//
//  ViewModelFactory.swift
//  TVMaze
//
//  Created by Andrea De vito on 22/10/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Boomerang
import Kingfisher

protocol SceneViewModelFactory {
    func showCastDetailViewModel (person: Person) -> ShowCastDetailViewModel
    func showDetailViewModel (show: Show) -> ShowDetailViewModel
    func searchViewModel () -> SearchViewModel
    func scheduleViewModel () -> ScheduleViewModel
    func showSeasonDetailViewModel (season: Season) -> ShowSeasonDetailViewModel
    func homePager() -> PagerViewModel
}

class SceneViewModelFactoryImplementations: SceneViewModelFactory {

    let container: AppContainer
    let useCaseContainer: UseCaseContainer

    init(container: AppContainer, useCaseContainer: UseCaseContainer) {
        self.container = container
        self.useCaseContainer = useCaseContainer
    }

    func showDetailViewModel(show: Show) -> ShowDetailViewModel {
        ShowDetailViewModel(show: show,
                            routeFactory: container.routes,
                            components: container.componentViewModels,
                            container: useCaseContainer)
    }

    func searchViewModel() -> SearchViewModel {
        SearchViewModel(routeFactory: container.routes,
                        components: container.componentViewModels,
                        useCase: useCaseContainer.search)
    }

    func showCastDetailViewModel(person: Person) -> ShowCastDetailViewModel {
        ShowCastDetailViewModel(person: person,
                                routeFactory: container.routes,
                                components: container.componentViewModels,
                                useCase: useCaseContainer.castDetail)
    }

    func scheduleViewModel() -> ScheduleViewModel {
        ScheduleViewModel(routeFactory: container.routes,
                          components: container.componentViewModels,
                          useCase: useCaseContainer.schedule)
    }

    func showSeasonDetailViewModel(season: Season) -> ShowSeasonDetailViewModel {
        ShowSeasonDetailViewModel(season: season,
                                  routeFactory: container.routes,
                                  components: container.componentViewModels,
                                  useCase: useCaseContainer.season)
    }

    func homePager() -> PagerViewModel {
        PagerViewModel(pages: [
            container.sceneViewModels.scheduleViewModel(),
            container.sceneViewModels.searchViewModel()

        ],
        layout: .tab)
    }

}
