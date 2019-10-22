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
    init(string: String) {
        self.title = string
    }
}

class TestViewModel: ItemViewModel, ListViewModel {
    var itemIdentifier: ItemIdentifier = "VC"
    var sections: [Section]
    
    init() {
        self.sections = [Section(items: (0..<10).map { TestItemViewModel(string: "\($0)") })]
    }
}
