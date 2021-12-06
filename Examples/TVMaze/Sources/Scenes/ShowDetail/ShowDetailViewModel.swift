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


class ShowDetailViewModel: RxListViewModel {
    var pageTitle : String {
        show.name
    }
    var disposeBag: DisposeBag = DisposeBag()
    
    let routeFactory : RouteFactory
    let routes: PublishRelay<Route> = .init()
    let uniqueIdentifier: UniqueIdentifier = UUID()
    let layoutIdentifier: LayoutIdentifier = SceneIdentifier.schedule
    let sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])
    let components : ComponentViewModelFactory
    private let show : Show
    let container : UseCaseContainer
    
    init(show : Show, routeFactory: RouteFactory, components: ComponentViewModelFactory, container : UseCaseContainer){
        
        self.show = show
        self.routeFactory = routeFactory
        self.components = components
        self.container = container
    }
    
    func reload() {
        
        let section = Section(items : [
            components.showInfo(self.show)
        ]
                              
                              
                                .compactMap{$0})
        
        container.detail.detail(show: show)
            .map{detail in
                var sections : [Section] =  [
                    section,
                    Section(items: [
                        self.components.detail(self.show.summary ?? " ")
                    ])
                ]
                
                if (!detail.seasons.isEmpty) {
                    sections.append(Section( items:
                                                [self.components.subTitle("Cast"),
                                                 self.components.castCarousel(castlist:detail.cast,
                                                                              routes:self.routes),
                                                 self.components.subTitle("Season"),
                                                 self.components.seasonCarousel(seasonlist: detail.seasons, show: self.show,
                                                                                routes: self.routes)]
                                           ))
                }
                return sections
            }
            .startWith(sections)
            .catchAndReturn([])
            .bind(to: sectionsRelay)
            .disposed(by: disposeBag)
        
    }
    
//    func elementSize(at indexPath: IndexPath, type: String?) -> ElementSize? {
//        guard type == nil else {return nil}
//        switch indexPath.section {
//        case 0 :
//            return Size.fixed(height: 50)
//        default: return Size.automatic()
//        }
//    }

    
    
    func sectionProperties(at index: Int) -> Size.SectionProperties {
        .init(insets: .init(top: 10, left: 10, bottom: 10, right: 10),
              lineSpacing: 10,
              itemSpacing: 10)
    }
    
    func selectItem(at indexPath: IndexPath) {
        if let person = (self [indexPath] as? CastViewModel)?.cast.person {
          details(person: person)
        }
    }
    
    func details (person : Person) {
        routes.accept(routeFactory.castDetails(person: person))
    }
}




