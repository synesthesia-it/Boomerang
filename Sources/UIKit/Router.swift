//
//  Router.swift
//  Boomerang
//
//  Created by Stefano Mondino on 05/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public protocol Route {}

public protocol ViewModelRoute: Route {
    var viewModel: ItemViewModel { get }
}

public protocol Router {
     func execute(_ route: Route, from source: Scene?)
}
