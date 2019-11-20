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

class RxScheduleViewModel: ViewModel, RxListViewModel, RxNavigationViewModel {
    let routes: PublishRelay<Route> = PublishRelay()
    
    let sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])
    
    let layoutIdentifier: LayoutIdentifier
    
    let disposeBag = DisposeBag()
    var reloadDisposeBag = DisposeBag()
    let routeFactory: RouteFactory
    let itemViewModelFactory: ItemViewModelFactory
    
    init(identifier: SceneIdentifier = .schedule,
         itemViewModelFactory: ItemViewModelFactory,
         routeFactory: RouteFactory) {
        self.layoutIdentifier = identifier
        self.itemViewModelFactory = itemViewModelFactory
        self.routeFactory = routeFactory
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
                        var sections = sections
                        if var first = sections.first {
                            first.items.shuffle()
                            sections[0] = first
                            return sections
                        }
                        return sections
                }
        }
        .bind(to: sectionsRelay)
        .disposed(by: reloadDisposeBag)
    }
    func mapEpisodes(_ episodes: [Episode]) -> [Section] {
        let count = 10
        let factory = self.itemViewModelFactory
        return [episodes.prefix(count),
                episodes.dropFirst(count)]
            .enumerated()
            .map {
                Section(id: "Schedule_\($0.offset)",
                    items: $0.element.compactMap { factory.episode($0) },
                    header: factory.header(title: "Tonight's schedule \($0.offset)"),
                    footer: factory.header(title: "Thanks! \($0.offset)")
                    
                )
        }
    }
    
    func selectItem(at indexPath: IndexPath) {
        if let viewModel = self[indexPath] as? ShowViewModel {
            onNavigation(routeFactory.detailRoute(show: viewModel.show))
        }
    }
}
