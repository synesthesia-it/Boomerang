//
//  ScheduleViewModel.swift
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

class ScheduleViewModel: RxListViewModel, RxNavigationViewModel, PageViewModel {
    public var pageTitle: String = "Schedule"
    public var pageIcon: UIImage? = .init(named: "schedule")
    var disposeBag: DisposeBag = DisposeBag()

    let routes: PublishRelay<Route> = .init()
    let routeFactory: RouteFactory
    let uniqueIdentifier: UniqueIdentifier = UUID()
    let layoutIdentifier: LayoutIdentifier = SceneIdentifier.schedule
    let sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])
    let components: ComponentViewModelFactory
    let useCase: ScheduleUseCase

    init(routeFactory: RouteFactory, components: ComponentViewModelFactory, useCase: ScheduleUseCase) {
        self.routeFactory = routeFactory
        self.components = components
        self.useCase = useCase
    }

    func reload() {
        let components = self.components
            useCase.schedule()
            .map { episodes in
                episodes
                .compactMap { $0.show }
                             .sorted(by: {($0.weight ?? 0) > ($1.weight ?? 0)})
            }
            .map { episodes in

                let sections: [Section] = [
                    Section(
                        id: "Header",
                        items:
                                episodes
                                .prefix(2)
                                .map { components.scheduleShow($0) }),

                    Section(
                        id: "Rest",
                        items: episodes
                                .dropFirst(2)
                                .map { components.scheduleShow($0) })

                ]

                return sections
            }
            .catchAndReturn([])
            .bind(to: sectionsRelay)
            .disposed(by: disposeBag)
    }

    func elementSize(at indexPath: IndexPath, type: String?) -> ElementSize? {
        guard type == nil else { return nil }
        while indexPath.section < 1 { return Size.aspectRatio(210/295, itemsPerLine: 2)}
        return Size.aspectRatio(210/295, itemsPerLine: 3)
    }

    func sectionProperties(at index: Int) -> Size.SectionProperties {
        .init(insets: .init(top: 10, left: 10, bottom: 10, right: 10),
              lineSpacing: 4,
              itemSpacing: 4)
    }

    func selectItem(at indexPath: IndexPath) {
        if let show = (self[indexPath] as? ScheduleShowViewModel)?.show {
            details(show: show)
        }
    }

    func search () {
        routes.accept(routeFactory.search())
    }

    func details (show: Show) {
        routes.accept(routeFactory.details(show: show))
    }

}

//    var sections: [Section] = [] {
//        didSet{
//            onUpdate()
//        }
//    }
//    var onUpdate: () -> Void = {}
