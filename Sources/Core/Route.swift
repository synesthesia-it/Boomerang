//
//  Router.swift
//  Boomerang
//
//  Created by Stefano Mondino on 05/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
///A Scene generically represents a "screen" of the app. On UIKit apps, it can be a `UIViewController`
public protocol Scene {}

///An object representing the *intent* of navigating from a `Scene` to a new one
public protocol Route {

    ///A closure that should be called upon Route's execution responsible of destination Scene's creation
    var createScene: () -> Scene? { get }

    ///Execute the route from source `scene` 
    func execute<T: Scene>(from scene: T?)
}
