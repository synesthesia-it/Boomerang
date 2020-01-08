//
//  NavigationViewModel.swift
//  Boomerang
//
//  Created by Stefano Mondino on 01/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
/**
    A view model exposing routes to navigate the app
 */
public protocol NavigationViewModel: ViewModel {
    ///A callback externally set that should be called whenever a new route should be executed.
    var onNavigation: (Route) -> Void { get set }
}
