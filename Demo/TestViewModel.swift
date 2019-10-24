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

class TestViewModel: ItemViewModel, ListViewModel {
    var onUpdate: () -> () = {}
    var onNavigation: (Route) -> () = { _ in }
    
    let itemIdentifier: ItemIdentifier
    
    var sections: [Section] = [] {
        didSet {
            onUpdate()
        }
    }
    
    init(identifier: SceneIdentifier = .main) {
        self.itemIdentifier = identifier
        //self.sections = [Section(items: (0..<10).map { TestItemViewModel(string: "\($0)") })]
        let task = URLSession.shared.task([Episode].self, api: .schedule) {[weak self] result in
            switch result {
            case .success(let episodes):
                self?.sections = [Section(items: episodes.map { ShowItemViewModel(episode: $0)})]
            case .failure(let error):
                print(error)
            }
        }
        task.resume()
    }
        
    func selectItem(at indexPath: IndexPath) {
        if let viewModel = self[indexPath] {
            onNavigation(NavigationRoute(viewModel: viewModel))
        }
    }
}
