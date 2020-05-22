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

    init(createScene: @escaping () -> UIViewController?) {
        self.createViewController = createScene
    }

    func execute<T: UIViewController>(from scene: T?) {
        guard let pax = scene?.pax.controller,
        let destination = createViewController() else { return }
        pax.setMainViewController(destination, animated: true)
    }
}
