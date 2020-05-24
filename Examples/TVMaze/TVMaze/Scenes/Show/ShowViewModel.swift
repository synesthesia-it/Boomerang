//
//  ShowUseCaseViewModel.swift
//  TVMaze
//

import Foundation
import Boomerang
import RxBoomerang
import RxSwift
import RxRelay

class ShowViewModel: RxListViewModel, RxNavigationViewModel, WithEntity {

    var sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])
    
    var routes: PublishRelay<Route> = PublishRelay()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    var layoutIdentifier: LayoutIdentifier = SceneIdentifier.show
    
    let itemViewModelFactory: ItemViewModelFactory

    private let useCase: ShowDetailUseCase
    
    let routeFactory: RouteFactory
    
    let uniqueIdentifier: UniqueIdentifier = UUID()
    let show: WithShow

    var entity: Entity { show }

    var title: String {
        show.show.name
    }
    init(show: WithShow,
         itemViewModelFactory: ItemViewModelFactory,
         useCase: ShowDetailUseCase,
         routeFactory: RouteFactory) {
        self.show = show
        self.useCase = useCase
        self.routeFactory = routeFactory
        self.itemViewModelFactory = itemViewModelFactory
    }
    
    func reload() {
        disposeBag = DisposeBag()
        //Bind here to use case and set sectionsRelay
    }
    
    func selectItem(at indexPath: IndexPath) {

    }        
}
