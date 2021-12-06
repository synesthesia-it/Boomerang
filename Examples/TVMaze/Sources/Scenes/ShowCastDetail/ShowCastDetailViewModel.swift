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


class ShowCastDetailViewModel: RxListViewModel {
    
    let routes: PublishRelay<Route> = .init()
    
   
    var pageTitle : String {
        person.name
    }
    var disposeBag: DisposeBag = DisposeBag()
   
    let routeFactory : RouteFactory
    let uniqueIdentifier: UniqueIdentifier = UUID()
    let layoutIdentifier: LayoutIdentifier = SceneIdentifier.schedule
    let sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])
    let components : ComponentViewModelFactory
    let person : Person
    let useCase: DetailCastUseCase
    
    
    init(person : Person, routeFactory : RouteFactory, components: ComponentViewModelFactory, useCase: DetailCastUseCase){
        self.person = person
        self.routeFactory = routeFactory
        self.components = components
        self.useCase = useCase
    }
    
    func reload() {
        

        let section = Section(items : [components.title(self.person.name),
//                                      PersonViewModel(person: person),
            
                                       
                                     
                                     
                                      ]
                                .compactMap{$0})
        
        useCase.detail(person: person)
            .debug()
            .map{ actorDetail in
                [   section,
                    Section(items: [
                        self.components.actor(actorDetail.actorInfo)
                    ]),
                    Section(items : actorDetail.credits
                                                .map{ credit in
                            self.components.show(credit._embedded.show)
                        })]
                            
                            
                        }
            .startWith([section])
            .bind(to: sectionsRelay)
            .disposed(by: disposeBag)
        
        
    }
    
    func elementSize(at indexPath: IndexPath, type: String?) -> ElementSize? {
        guard type == nil else {return nil}
        switch indexPath.section {
        case 0 :
            return Size.fixed(height: 50)
            
        case 1 :
            return Size.aspectRatio(16/9, itemsPerLine: 1)
            
            
        case 2 :
            return Size.aspectRatio(9/16, itemsPerLine: 3)
        default: return Size.automatic()
        }
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




