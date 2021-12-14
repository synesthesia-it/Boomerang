//
//  AlertRoute.swift
//  GameOfFifteen_iOS
//
//  Created by Stefano Mondino on 05/12/21.
//

import Foundation
import Boomerang
import UIKit
struct AlertRoute: UIKitRoute {
    struct Action {
        let title: String
        let callback: () -> Void
    }
    let createViewController: () -> UIViewController?

    init(title: String,
         message: String,
         actions: [Action]) {
        createViewController = {
            let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
            actions
                .map { value in .init(title: value.title, style: .default) { _ in value.callback() } }
                .forEach { controller.addAction($0) }
            return controller
        }
    }

    func execute<T>(from scene: T?) where T: UIViewController {
        if let controller = createViewController() {
            scene?.present(controller, animated: true, completion: nil)
        }
    }

}
