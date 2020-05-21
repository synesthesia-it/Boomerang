//
//  Scene.swift
//  Demo
//
//  Created by Stefano Mondino on 12/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
#if !COCOAPODS
@_exported import Boomerang
#endif

extension UIViewController: Scene {}

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

public extension ListViewModel {

    ///Easily retrieves an item through its index path. If index path is out of bounds, `nil` is returned.
    subscript(index: IndexPath) -> ViewModel? {

            guard index.count == 2,
                sections.count > index.section,
                sections[index.section].items.count > index.item
                else { return nil }
            return sections[index.section].items[index.item]
    }
}
