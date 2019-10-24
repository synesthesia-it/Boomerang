//
//  ShowItemViewModel.swift
//  Demo
//
//  Created by Stefano Mondino on 24/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

class ShowItemViewModel: ItemViewModel {
    
    let itemIdentifier: ItemIdentifier
    
    var title: String
    
    init(episode: Episode, identifier: ViewIdentifier = .show) {
        self.itemIdentifier = identifier
        self.title = episode.name
    }
}
