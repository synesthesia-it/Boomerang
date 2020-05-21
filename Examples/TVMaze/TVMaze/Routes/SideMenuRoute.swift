//
//  SideMenuRoute.swift
//  TVMaze
//
//  Created by Stefano Mondino on 21/05/2020.
//  Copyright © 2020 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
import Pax
import UIKitBoomerang

struct SideMenuRoute: UIKitRoute {

    let createViewController: () -> UIViewController?

    init() {
        self.createViewController = {
            let pax = Pax()
            return pax
        }
    }

    func execute<T: UIViewController>(from scene: T?) {
        RestartRoute(createScene: self.createViewController)
            .execute(from: scene)
    }
}
