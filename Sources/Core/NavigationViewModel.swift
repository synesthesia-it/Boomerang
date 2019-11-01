//
//  NavigationViewModel.swift
//  Boomerang
//
//  Created by Stefano Mondino on 01/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public protocol NavigationViewModel: AnyObject {
    var onNavigation: (Route) -> () { get set }
}
