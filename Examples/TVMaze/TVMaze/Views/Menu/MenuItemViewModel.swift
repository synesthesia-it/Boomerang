//
//  MenuItemViewModel.swift
//  TVMaze
//
//  Created by Stefano Mondino on 21/05/2020.
//  Copyright © 2020 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

class MenuItemViewModel: ViewModel {
    var uniqueIdentifier: UniqueIdentifier = UUID()

    var layoutIdentifier: LayoutIdentifier

    let title: String

    let item: MenuItem

    init(item: MenuItem,
        layout: LayoutIdentifier = ItemIdentifier.menu) {
        self.layoutIdentifier = layout
        self.title = item.rawValue
        self.item = item
    }
}
