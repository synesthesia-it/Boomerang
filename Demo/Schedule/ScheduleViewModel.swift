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
    let viewModel: ItemViewModel
}

class ScheduleViewModel: ItemViewModel, ListViewModel {
    var onUpdate: () -> () = {}
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
        if let viewModel = self[indexPath] {
            onNavigation(NavigationRoute(viewModel: viewModel))
        }
    }
}
