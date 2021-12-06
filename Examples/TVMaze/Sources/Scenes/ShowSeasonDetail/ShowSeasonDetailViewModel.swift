//
//  ShowDetailsViewModel.swift
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
import RxRelay


class ShowSeasonDetailViewModel: RxListViewModel {
    
    let routes: PublishRelay<Route> = .init()
    
   
    var pageTitle : String {
        " "
    }
    var disposeBag: DisposeBag = DisposeBag()
   
    let routeFactory : RouteFactory
    let uniqueIdentifier: UniqueIdentifier = UUID()
    let layoutIdentifier: LayoutIdentifier = SceneIdentifier.schedule
    let sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])
    let components : ComponentViewModelFactory
    let season : Season
    let useCase: DetailSeasonUseCase
    
    
    init(season : Season, routeFactory : RouteFactory, components: ComponentViewModelFactory, useCase: DetailSeasonUseCase){
        self.season = season
        self.routeFactory = routeFactory
        self.components = components
        self.useCase = useCase
    }
    
    func reload() {
        
        
        let section = Section(items : [components.title("Stagione n^: \(self.season.number)" ),
                                       components.summary("Episode: \(self.season.episodeOrder ?? 0)"),
                                       components.summary("Premier: \(self.season.premiereDate ?? " ")")
                                      ])
        
        useCase.detail(season: season)
            .debug()
            .catchAndReturn([])
            .map{episodelist in
                [
                    section,
                    Section(items : episodelist.map{ episode in
                        self.components.episode(episode)
                    })
                ]
            }
//            .startWith([section])
            .bind(to: sectionsRelay)
            .disposed(by: disposeBag)
    }
    
  
    func sectionProperties(at index: Int) -> Size.SectionProperties {
        .init(insets: .init(top: 10, left: 10, bottom: 10, right: 10),
              lineSpacing: 10,
              itemSpacing: 10)
    }
    
    func selectItem(at indexPath: IndexPath) {
        if let show = (self[indexPath] as? ShowViewModel)?.show {
            details(show: show)
        }
    }
    
    func details (show : Show) {
        routes.accept(routeFactory.details(show : show))
    }
}




