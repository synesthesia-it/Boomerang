//
//  ShowUseCaseViewModel.swift
//  TVMaze
//

import Foundation
import Boomerang
import RxBoomerang
import RxSwift
import RxRelay

class ShowsViewModel: RxListViewModel, RxNavigationViewModel {

    var sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])
    
    var routes: PublishRelay<Route> = PublishRelay()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let layoutIdentifier: LayoutIdentifier = SceneIdentifier.shows

    let uniqueIdentifier: UniqueIdentifier = UUID()

    let itemViewModelFactory: ItemViewModelFactory

    private let useCase: ShowsUseCase

    let routeFactory: RouteFactory

    let title: String
    
    init(itemViewModelFactory: ItemViewModelFactory,
         title: String,
         useCase: ShowsUseCase,
         routeFactory: RouteFactory) {
        self.title = title
        self.useCase = useCase
        self.routeFactory = routeFactory
        self.itemViewModelFactory = itemViewModelFactory
    }

    private var reloadDisposeBag = DisposeBag()

    func reload() {
        reloadDisposeBag = DisposeBag()
        let factory = self.itemViewModelFactory
        useCase.shows()
            .map { [Section(items: $0.map { factory.show($0.show, hideTitle: true) })]}
            .bind(to: sectionsRelay)
            .disposed(by: reloadDisposeBag)
    }

    func selectItem(at indexPath: IndexPath) {
        if let model = self[indexPath]?.get(on: ShowItemViewModel.self, from: \.show) {
            self.routes.accept(routeFactory.detail(for: model))
//            self.routes.accept(routeFactory.schedule())
        }
    }        
}
