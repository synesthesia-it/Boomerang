//
//  TestViewModel.swift
//  NewArch
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

extension String: ItemIdentifier {
    
}


class TestItemViewModel: ItemViewModel {
    var itemIdentifier: ItemIdentifier = "Test"
    
    var title: String
    init(episode: Episode) {
        self.title = episode.name
    }
}

class TestViewModel: ItemViewModel, ListViewModel {
    var onUpdate: () -> () = {}
    var onNavigation: () -> () = {}
    
    var itemIdentifier: ItemIdentifier = "VC"
    
    var sections: [Section] = [] {
        didSet {
            onUpdate()
        }
    }
    
    init() {
        //self.sections = [Section(items: (0..<10).map { TestItemViewModel(string: "\($0)") })]
        let task = URLSession.shared.task([Episode].self, api: .schedule) {[weak self] result in
            switch result {
            case .success(let episodes):
                self?.sections = [Section(items: episodes.map { TestItemViewModel(episode: $0)})]
            case .failure(let error):
                print(error)
            }
        }
        task.resume()
    }
        
    func selectItem(at indexPath: IndexPath) {
        
    }
}
