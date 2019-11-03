//
//  TestViewModel.swift
//  NewArch
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

struct NavigationRoute: ViewModelRoute {
    var destination: Scene?
    let viewModel: ViewModel
}

class ScheduleViewModel: ViewModel, ListViewModel, NavigationViewModel {
    var onUpdate: () -> () = {}
    var sections: [Section] = [] {
        didSet {
            onUpdate()
        }
    }
    var onNavigation: (Route) -> () = { _ in }
    
    let layoutIdentifier: LayoutIdentifier
    
    var downloadTask: Task?
    
    init(identifier: SceneIdentifier = .schedule) {
        self.layoutIdentifier = identifier
    }
    func reload() {
        downloadTask?.cancel()
        downloadTask = URLSession.shared.getEntity([Episode].self, from: .schedule) {[weak self] result in
            switch result {
            case .success(let episodes):
                self?.sections = [Section(id: "Schedule", 
                                          items: episodes.map { ShowViewModel(episode: $0)},
                                          header: HeaderViewModel(title: "Tonight's schedule"),
                                          footer: HeaderViewModel(title: "Thank you for watching")
                    )]
            case .failure(let error):
                print(error)
            }
        }
    }
    func selectItem(at indexPath: IndexPath) {
        if let viewModel = self[indexPath] as? ShowViewModel {
            onNavigation(NavigationRoute(viewModel: ShowDetailViewModel(show: viewModel.show)))
        }
    }
}

