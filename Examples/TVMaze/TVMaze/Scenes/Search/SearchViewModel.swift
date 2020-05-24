//
//  SearchUseCaseViewModel.swift
//  TVMaze
//

import Foundation
import Boomerang
import RxSwift
import RxRelay
import RxBoomerang

class SearchViewModel: RxListViewModel, RxNavigationViewModel {
    
    var uniqueIdentifier: UniqueIdentifier = UUID()
    
    var sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])
    
    var routes: PublishRelay<Route> = PublishRelay()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    var layoutIdentifier: LayoutIdentifier = SceneIdentifier.search
    
    let itemViewModelFactory: ItemViewModelFactory
    
    private let useCase: SearchUseCase
    
    let routeFactory: RouteFactory
    
    let searchString = BehaviorRelay<String?>(value: nil)
    
    init(itemViewModelFactory: ItemViewModelFactory,
         useCase: SearchUseCase,
         routeFactory: RouteFactory) {
        self.useCase = useCase
        self.routeFactory = routeFactory
        self.itemViewModelFactory = itemViewModelFactory
    }
    
    func reload() {
        disposeBag = DisposeBag()
        let useCase = self.useCase
        searchString
            .debounce(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .map { $0 ?? "" }
            .flatMapLatest {[weak self] query in
                useCase.all(query: query)
                    .map { [weak self] in self?.createSections(from: $0) ?? [] }
        }
        .bind(to: sectionsRelay)
        .disposed(by: disposeBag)
    }
    
    private func createSections(from result: SearchUseCase.Result) -> [Section] {
        let factory = self.itemViewModelFactory
        let shows = result.shows.map { factory.show($0, hideTitle: false) }
        let people = result.people.map { factory.person($0) }
        return [Section(id: "Shows", items: shows, header: factory.header("Shows")),
                Section(id: "People", items: people, header: factory.header("People"))]
            .filter { $0.items.count > 0}
    }

    func selectItem(at indexPath: IndexPath) {
        if let entity = self[indexPath]?.extractEntity() {
            switch entity {
            case let person as Person:
                self.routes.accept(routeFactory.credits(for: person))
            default: break
            }
        }
    }        
}
