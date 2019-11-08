//
//  HeaderViewModel.swift
//  Demo
//
//  Created by Stefano Mondino on 03/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

class HeaderViewModel: ViewModel {
    let layoutIdentifier: LayoutIdentifier
    let title: String
    var uniqueIdentifier: UniqueIdentifier {
        return title
    }
    init(title: String, identifier: ViewIdentifier = .header) {
        self.layoutIdentifier = identifier
        self.title = title
    }
}
