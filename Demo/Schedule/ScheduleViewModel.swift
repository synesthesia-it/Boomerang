//
//  TestViewModel.swift
//  NewArch
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import RxSwift
import RxRelay

struct NavigationRoute: ViewModelRoute {
    var destination: Scene?
    let viewModel: ItemViewModel
}

class ScheduleViewModel: ItemViewModel, RxListViewModel {
//    var onUpdate: () -> () = {}
    let observableSections: BehaviorRelay<[Section]> = BehaviorRelay(value: [])
    var onNavigation: (Route) -> () = { _ in }
    
    let itemIdentifier: ItemIdentifier
    
    var sections: [Section] = [] {
        didSet {
            onUpdate()
        }
    }
    var downloadTask: Task?
    init(identifier: SceneIdentifier = .schedule) {
        self.itemIdentifier = identifier
        
        downloadTask = URLSession.shared.getEntity([Episode].self, from: .schedule) {[weak self] result in
            switch result {
            case .success(let episodes):
                self?.sections = [Section(items: episodes.map { ShowItemViewModel(episode: $0)})]
            case .failure(let error):
                print(error)
            }
        }
    }
        
    func selectItem(at indexPath: IndexPath) {
        if let viewModel = self[indexPath] as? ShowItemViewModel {
            onNavigation(NavigationRoute(viewModel: ShowDetailViewModel(show: viewModel.show)))
        }
    }
}

protocol RxListViewModel: ListViewModel {
    var observableSections: BehaviorRelay<[Section]> { get }
    
}
extension RxListViewModel {
    var onUpdate: () -> () {
        return {[weak self] in self?.observableSections.accept(self?.sections ?? []) }
    }
}
extension Reactive where Base: RxListViewModel {
    var sections: Observable<[Section]> {
        return base.observableSections.asObservable()
    }
}
