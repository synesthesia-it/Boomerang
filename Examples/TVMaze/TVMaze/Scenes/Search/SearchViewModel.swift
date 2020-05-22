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
        searchString.asObservable()
            .debounce(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .flatMapLatest { useCase.shows(query: $0 ?? "") }
            .map { [Section(items: $0.map { ShowItemViewModel(show: $0)})] }
            .bind(to: sectionsRelay)
            .disposed(by: disposeBag)
    }
    
    func selectItem(at indexPath: IndexPath) {

    }        
}
