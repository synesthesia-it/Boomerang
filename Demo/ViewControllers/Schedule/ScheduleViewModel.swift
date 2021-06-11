//
//  TestViewModel.swift
//  NewArch
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

// struct NavigationRoute: ViewModelRoute {
//    var destination: Scene?
//    let viewModel: ViewModel
// }

class ScheduleViewModel: ListViewModel, NavigationViewModel {
    var onUpdate: () -> Void = {}
    var sections: [Section] = [] {
        didSet {
            onUpdate()
        }
    }
    var onNavigation: (Route) -> Void = { _ in }

    let layoutIdentifier: LayoutIdentifier
    let uniqueIdentifier: UniqueIdentifier = UUID()
    var downloadTask: Task?
    let routeFactory: RouteFactory
    let itemViewModelFactory: ItemViewModelFactory
    let cellIdentifier: ViewIdentifier
    init(identifier: SceneIdentifier = .schedule,
         itemViewModelFactory: ItemViewModelFactory,
         cellIdentifier: ViewIdentifier = .show,
         routeFactory: RouteFactory) {
        self.layoutIdentifier = identifier
        self.routeFactory = routeFactory
        self.itemViewModelFactory = itemViewModelFactory
        self.cellIdentifier = cellIdentifier
    }
    func canDeleteItem(at indexPath: IndexPath) -> Bool {
        return true
    }
    func deleteItem(at indexPath: IndexPath) -> ViewModel? {
        let section = self.sections[indexPath.section].removing(at: indexPath.item)
        sections[indexPath.section] = section
        return nil
    }
    func reload() {
        downloadTask?.cancel()
        let factory = itemViewModelFactory
        downloadTask = URLSession.shared.getEntity([Episode].self, from: .schedule) {[weak self] result in
            switch result {
            case .success(let episodes):
                self?.sections = [Section(id: "Schedule",
                                          items: episodes.compactMap { factory.episode($0, identifier: self?.cellIdentifier ?? .show) },
                                          header: factory.header(title: "Tonight's schedule"),
                                          footer: factory.header(title: "Thank you for watching")
                ),
                Section(id: "Boxed",
                                         items: [BoxedViewModel()])]
            case .failure(let error):
                print(error)
            }
        }
    }
    func selectItem(at indexPath: IndexPath) {
        if let viewModel = self[indexPath] as? ShowViewModel {
            onNavigation(routeFactory.detailRoute(show: viewModel.show))
        }
    }
    func sectionProperties(at index: Int) -> Size.SectionProperties {
        .zero
    }
}
