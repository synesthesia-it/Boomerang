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
    
    let layoutIdentifier: LayoutIdentifier
    var uniqueIdentifier: UniqueIdentifier
    var title: String
    let show: Show
    var uuid: String = UUID().uuidString
    init(episode: Episode, identifier: ViewIdentifier = .show) {
        self.layoutIdentifier = identifier
        self.title = episode.name
        self.show = episode.show
        self.uniqueIdentifier = self.title + "_\(show.id)"
    }
}
