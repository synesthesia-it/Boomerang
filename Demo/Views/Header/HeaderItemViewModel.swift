//
//  HeaderItemViewModel.swift
//  Boomerang
//
//  Created by Stefano Mondino on 05/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

class HeaderItemViewModel: IdentifiableItemViewModelType {
    
    var identifier: Identifier = Identifiers.Views.header
    var title: String
    init (title: String) {
        self.title = title
    }
}
