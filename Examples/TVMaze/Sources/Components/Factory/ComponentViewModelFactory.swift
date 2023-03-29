//
//  EpisodeViewModel.swift
//  TVMaze
//
//  Created by Andrea De vito on 15/10/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Boomerang
import Kingfisher

protocol ComponentViewModelFactory {
    func title (_ title: String) -> ViewModel
    func subTitle (_ subTitle: String) -> ViewModel
    func detail(_ detail: String) -> ViewModel
    func image (url: URL?) -> ViewModel?
    func showInfo (_ show: Show) -> ViewModel
    func summary (_ summary: String) -> ViewModel
    func show (_ show: Show) -> ViewModel
    func scheduleShow (_ show: Show) -> ViewModel
    func episode (_ episode: Episode) -> ViewModel
    func cast (_ cast: Cast) -> ViewModel
    func actor(_ actorDetail: Actor) -> ViewModel
    func castDetail (_ cast: Cast) -> ViewModel
    func season(_ season: Season, _ show: Show) -> ViewModel
    func castCarousel(castlist: [Cast], routes: PublishRelay<Route>) -> ViewModel
    func seasonCarousel(seasonlist: [Season], show: Show, routes: PublishRelay<Route>) -> ViewModel
}

class ComponentViewModelFactoryImplementation: ComponentViewModelFactory {

    let container: AppContainer

    init(container: AppContainer) {
        self.container = container
    }

    func cast(_ cast: Cast) -> ViewModel {
        CastViewModel(cast: cast)
    }

    func castDetail(_ cast: Cast) -> ViewModel {
        CastViewModel(cast: cast)
    }

    func actor(_ actorDetail: Actor) -> ViewModel {
        ActorViewModel(actor: actorDetail)
    }

    func season(_ season: Season, _ show: Show) -> ViewModel {
        SeasonViewModel(season: season, show: show)
    }

    func show(_ show: Show) -> ViewModel {
        ShowViewModel(show: show)
    }

    func scheduleShow(_ show: Show) -> ViewModel {
        ScheduleShowViewModel(show: show)
    }

    func showInfo(_ show: Show) -> ViewModel {
        ShowInfoViewModel(show: show)
    }

    func episode(_ episode: Episode) -> ViewModel {
        EpisodeViewModel(episode: episode)
    }

    func image(url: URL?) -> ViewModel? {
        ImageVieModel(url: url, layout: .image)
    }

    func title(_ title: String) -> ViewModel {
        TitleViewModel(text: title, layout: .title)
    }

    func summary(_ summary: String) -> ViewModel {
        TitleViewModel(text: summary, layout: .summary)

    }

    func subTitle(_ subTitle: String) -> ViewModel {
        TitleViewModel(text: subTitle, layout: .subTitle)
    }

    func detail(_ detail: String) -> ViewModel {
        TitleViewModel(text: detail, layout: .detail)
    }

    func seasonCarousel(seasonlist: [Season], show: Show, routes: PublishRelay<Route>) -> ViewModel {
        let section = Section(items: seasonlist.map {
            self.season($0, show)
        })
        return CarouselViewModel(sections: [section], cells: container.components) {viewmodel in
            if let season = (viewmodel as? SeasonViewModel)?.season {
                routes.accept( self.container.routes.seasonDetail(season: season))
            }
        }
    }

    func castCarousel(castlist: [Cast], routes: PublishRelay<Route>) -> ViewModel {
        let section = Section(items: castlist.map {
            self.cast($0)
        })
        return CarouselViewModel(sections: [section], cells: container.components) {viewmodel in
            if let cast = (viewmodel as? CastViewModel)?.cast {
                routes.accept( self.container.routes.castDetails(person: cast.person))
            }
        }
    }

}
