//
//  ModalRoute.swift
//  Demo
//
//  Created by Stefano Mondino on 08/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import UIKit

struct ModalRoute: Route {
    let createScene: () -> Scene?
    init(createScene: @escaping () -> Scene) {
        self.createScene = createScene
    }
    func execute(from scene: Scene?) {
        if let destination = createScene() {
            scene?.present(destination, animated: true, completion: nil)
        }
    }
}
