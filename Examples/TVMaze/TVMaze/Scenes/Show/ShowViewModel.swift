//
//  ShowUseCaseViewModel.swift
//  TVMaze
//

import Foundation
import Boomerang
import RxBoomerang
import RxSwift
import RxRelay

typealias ShowUseCase = String

class ShowViewModel: RxListViewModel, RxNavigationViewModel {

    var sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])
    
    var routes: PublishRelay<Route> = PublishRelay()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    var layoutIdentifier: LayoutIdentifier = SceneIdentifier.show

    let uniqueIdentifier: UniqueIdentifier = UUID()

    let itemViewModelFactory: ItemViewModelFactory

    private let useCase: ShowUseCase

    let routeFactory: RouteFactory
    
    init(itemViewModelFactory: ItemViewModelFactory,
         useCase: ShowUseCase,
         routeFactory: RouteFactory) {
        self.useCase = useCase
        self.routeFactory = routeFactory
        self.itemViewModelFactory = itemViewModelFactory
    }

    private var reloadDisposeBag = DisposeBag()

    func reload() {
        reloadDisposeBag = DisposeBag()
        let factory = self.itemViewModelFactory
        URLSession.shared.rx
            .getEntity([Episode].self, from: .schedule)
            .map { [Section(items: $0.map { factory.show($0.show) })]}
            .bind(to: sectionsRelay)
            .disposed(by: reloadDisposeBag)
    }

    func selectItem(at indexPath: IndexPath) {
        if let model = self[indexPath]?.get(on: ShowItemViewModel.self, from: \.show) {
            self.routes.accept(routeFactory.showsRoute())
        }
    }        
}
