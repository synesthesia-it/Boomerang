//
//  TestViewModel.swift
//  NewArch
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import RxBoomerang
import RxSwift
import RxRelay

class RxScheduleViewModel: ItemViewModel, RxListViewModel, RxNavigationViewModel {
    let routes: PublishRelay<Route> = PublishRelay()
    
    let sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])
    
    let layoutIdentifier: LayoutIdentifier
    
    let disposeBag = DisposeBag()
    var reloadDisposeBag = DisposeBag()
    init(identifier: SceneIdentifier = .schedule) {
        self.layoutIdentifier = identifier
        
        
    }
    func reload() {
        self.reloadDisposeBag = DisposeBag()
        URLSession.shared.rx
            .getEntity([Episode].self, from: .schedule)
            .map(mapEpisodes(_:))
            .flatMapLatest { sections in
                Observable<Int>
                    .interval(.seconds(2), scheduler: MainScheduler.instance)
                    .startWith(0)
                    .map {_ in
                        sections.first?.items.shuffle() 
                        return sections
                }
        }
        .bind(to: sectionsRelay)
        .disposed(by: reloadDisposeBag)
    }
    func mapEpisodes(_ episodes: [Episode]) -> [Section] {
        return [episodes.prefix(3),
                episodes.dropFirst(3)]
            .enumerated()
            .map {
                Section(id: "Schedule_\($0.offset)", items:
                    $0.element
                        .map { ShowItemViewModel(episode: $0)})
        }
    }
    func selectItem(at indexPath: IndexPath) {
        if let viewModel = self[indexPath] as? ShowItemViewModel {
            onNavigation(NavigationRoute(viewModel: ShowDetailViewModel(show: viewModel.show)))
        }
    }
}

