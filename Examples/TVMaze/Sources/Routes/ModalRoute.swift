//
//  ModalRoute.swift
//  TVMaze
//
//  Created by Andrea De vito on 18/10/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Boomerang
import RxBoomerang

struct ModalRoute: UIKitRoute {
    var createViewController: () -> UIViewController?

    func execute<T: UIViewController>(from scene: T?) {
        if let scene = scene,
           let controller = createViewController() {
            scene.present(controller, animated: true, completion: nil)
        }
    }
}
