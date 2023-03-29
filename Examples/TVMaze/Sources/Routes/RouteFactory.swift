//
//  RouteFactory.swift
//  TVMaze
//
//  Created by Andrea De vito on 18/10/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Boomerang
import RxBoomerang

protocol RouteFactory {
    func restart() -> Route
    func search() -> Route
    func details(show: Show) -> Route
    func castDetails(person: Person) -> Route
    func seasonDetail(season: Season) -> Route
    func page(from viewModel: ViewModel) -> Route?
}

struct RouteFactoryImplementation: RouteFactory {

   let container: AppContainer

    init(container: AppContainer) {
        self.container = container
    }

    func page(from viewModel: ViewModel) -> Route? {
        switch viewModel {
        case let viewModel as ScheduleViewModel:
            return PageRoute {container.scenes.schedule()}

        case let viewModel as SearchViewModel:
            return PageRoute {container.scenes.search(viewModel: viewModel)}
        default: return nil
        }
    }

    func restart() -> Route {
        RestartRoute {
            UINavigationController(
                rootViewController:
                    container
                    .scenes
                    .mainTabBar())
        }
    }

    func search() -> Route {
        ModalRoute {
            UINavigationController(
                rootViewController:
                    container
                    .scenes
                    .search(
                    viewModel:
                        container
                        .sceneViewModels
                        .searchViewModel())
            )
        }
    }

    func details(show: Show) -> Route {
        NavigationRoute {
            container.scenes.showDetail(
                viewModel:
                    container
                    .sceneViewModels
                    .showDetailViewModel(show: show))
            //            ShowDetailViewController(
            //                viewModel: container.sceneViewModels.showDetailViewModel(show: show),
            //                components: self.container.components)
        }
    }

    func castDetails(person: Person) -> Route {
        NavigationRoute {
            container.scenes.showCastDetail(
                view:
                    container
                    .sceneViewModels
                    .showCastDetailViewModel(person: person))
        }

    }

    func seasonDetail(season: Season) -> Route {
        NavigationRoute {
            container.scenes.showSeasonDetail(
                view:
                    container
                    .sceneViewModels
                    .showSeasonDetailViewModel(season: season)
            )
        }
    }

}

