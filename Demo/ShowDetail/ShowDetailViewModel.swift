//
//  ShowDetailViewModel.swift
//  Demo
//
//  Created by Stefano Mondino on 24/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

class ShowDetailViewModel: ItemViewModel {
    let itemIdentifier: ItemIdentifier
    let title: String
    init(show: Show, identifier: SceneIdentifier = .showDetail) {
           self.itemIdentifier = identifier
        self.title = show.name
    }
}
