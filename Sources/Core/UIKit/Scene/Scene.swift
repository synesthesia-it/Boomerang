//
//  Scene.swift
//  Demo
//
//  Created by Stefano Mondino on 12/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//
#if os(iOS) || os(tvOS)
import Foundation
import UIKit

extension UIViewController: Scene {}
/// A route triggered by a UIViewController
public protocol UIKitRoute: Route {
    var createViewController: () -> UIViewController? { get }
    func execute<T>(from scene: T?) where T: UIViewController
}
public extension UIKitRoute {
    var createScene: () -> Scene? { createViewController }

    func execute<T: Scene>(from scene: T?) {
        self.execute(from: scene as? UIViewController)
    }
}
#endif
