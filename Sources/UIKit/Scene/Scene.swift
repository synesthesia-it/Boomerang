//
//  Scene.swift
//  Demo
//
//  Created by Stefano Mondino on 12/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController: Scene {}

public protocol UIKitRoute: Route {
    func execute<T>(from scene: T?) where T: UIViewController
}
public extension UIKitRoute {
    func execute<T: Scene>(from scene: T?) {
        self.execute(from: scene as? UIViewController)
    }
}
