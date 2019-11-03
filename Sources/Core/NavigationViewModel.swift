//
//  NavigationViewModel.swift
//  Boomerang
//
//  Created by Stefano Mondino on 01/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public protocol NavigationViewModel: ViewModel {
    var onNavigation: (Route) -> Void { get set }
}
