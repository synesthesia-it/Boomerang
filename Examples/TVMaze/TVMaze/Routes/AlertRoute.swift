//
//  AlertRoute.swift
//  Demo
//
//  Created by Stefano Mondino on 08/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKitBoomerang
import UIKit

struct AlertRoute: UIKitRoute {
    let createViewController: () -> UIViewController?
    init(title: String) {
        self.createViewController = {
            let controller = UIAlertController(title: title, message: "This is a message", preferredStyle: .actionSheet)
            controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return controller
        }
    }
    func execute<T>(from scene: T?) where T: UIViewController {
        if let destination = createViewController() {
            scene?.present(destination, animated: true, completion: nil)
        }
    }
}
