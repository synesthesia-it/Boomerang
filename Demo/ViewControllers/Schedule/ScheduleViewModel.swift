//
//  TestViewModel.swift
//  NewArch
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

//struct NavigationRoute: ViewModelRoute {
//    var destination: Scene?
//    let viewModel: ViewModel
//}

class ScheduleViewModel: ListViewModel, NavigationViewModel {
    var onUpdate: () -> Void = {}
    var sections: [Section] = [] {
        didSet {
            onUpdate()
        }
    }
    var onNavigation: (Route) -> Void = { _ in }

    let layoutIdentifier: LayoutIdentifier

    var downloadTask: Task?
    let routeFactory: RouteFactory
    let itemViewModelFactory: ItemViewModelFactory
    init(identifier: SceneIdentifier = .schedule,
         itemViewModelFactory: ItemViewModelFactory,
         routeFactory: RouteFactory) {
        self.layoutIdentifier = identifier
        self.routeFactory = routeFactory
        self.itemViewModelFactory = itemViewModelFactory
        
    }
    func reload() {
        downloadTask?.cancel()
        let factory = itemViewModelFactory
        downloadTask = URLSession.shared.getEntity([Episode].self, from: .schedule) {[weak self] result in
            switch result {
            case .success(let episodes):
                self?.sections = [Section(id: "Schedule",
                                          items: episodes.compactMap { factory.episode($0) },
                                          header: factory.header(title: "Tonight's schedule"),
                                          footer: factory.header(title: "Thank you for watching")
                    )]
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
}
