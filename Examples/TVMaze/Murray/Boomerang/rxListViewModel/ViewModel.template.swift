//
//  {{ name|firstUppercase }}UseCaseViewModel.swift
//  {{ target }}
//

import Foundation
import Boomerang
import RxSwift
import RxRelay
import Model

class {{ name|firstUppercase }}ViewModel: RxListViewModel, RxNavigationViewModel {
        
    var sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])
    
    var routes: PublishRelay<Route> = PublishRelay()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    var layoutIdentifier: LayoutIdentifier = SceneIdentifier.{{ name|firstLowercase }}
    
    let itemViewModelFactory: ItemViewModelFactory

    private let useCase: {{ name|firstUppercase }}UseCase
    
    let styleFactory: StyleFactory
    
    let routeFactory: RouteFactory
    
    init(itemViewModelFactory: ItemViewModelFactory,
         useCase: {{ name|firstUppercase }}UseCase,
         styleFactory: StyleFactory,
         routeFactory: RouteFactory) {
        self.useCase = useCase
        self.routeFactory = routeFactory
        self.styleFactory = styleFactory
        self.itemViewModelFactory = itemViewModelFactory
    }
    
    func reload() {
        disposeBag = DisposeBag()
		//Bind here to use case and set sectionsRelay
    }
    
    func selectItem(at indexPath: IndexPath) {
    
    }        
}
