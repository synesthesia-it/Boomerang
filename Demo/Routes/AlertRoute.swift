//
//  AlertRoute.swift
//  Demo
//
//  Created by Stefano Mondino on 08/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import UIKit

struct AlertRoute: Route {
    let createScene: () -> Scene?
    init(title: String) {
        self.createScene = {
            let controller = UIAlertController(title: title, message: "This is a message", preferredStyle: .actionSheet)
            controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return controller
        }
    }
    func execute(from scene: Scene?) {
        if let destination = createScene() {
            scene?.present(destination, animated: true, completion: nil)
        }
    }
}
