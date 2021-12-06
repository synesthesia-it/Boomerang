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
import RxBoomerang
import RxRelay

class SearchViewModel: RxListViewModel, PageViewModel{
    
    public var pageTitle: String = "Search"
    public var pageIcon: UIImage? = .init(named: "search")
    var disposeBag: DisposeBag = DisposeBag()
    
    let routeFactory : RouteFactory
    let routes: PublishRelay<Route> = .init()
    let uniqueIdentifier: UniqueIdentifier = UUID()
    let layoutIdentifier: LayoutIdentifier = SceneIdentifier.schedule
    let sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])
    let searchText = BehaviorRelay<String?>(value: nil)
    let components : ComponentViewModelFactory
    let useCase: SearchUseCase
 
    
    init(routeFactory: RouteFactory, components: ComponentViewModelFactory, useCase: SearchUseCase){
        self.routeFactory = routeFactory
        self.components = components
        self.useCase = useCase
    }
    
    func reload() {
        
        let useCase = self.useCase
            
        searchText
            .map{ $0 ?? ""}
            .filter{ $0.count > 2 }
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .flatMapLatest{  text -> Observable<[Search]> in
                useCase.search(text: text)
                    .catchAndReturn([])
            }
            .map{search in
                [
                 Section(items: search.map{self.components.show($0.show)
                    })]
                
            }
            .bind(to: sectionsRelay)
            .disposed(by: disposeBag)
        
        
            }
    
    func elementSize(at indexPath: IndexPath, type: String?) -> ElementSize? {
        guard type == nil else { return nil }
        return Size.aspectRatio(9/16, itemsPerLine: 3)
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
