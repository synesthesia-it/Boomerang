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

struct ModalRoute: UIKitRoute {
    
    let createViewController: () -> UIViewController?
    init(createScene: @escaping () -> UIViewController) {
        self.createViewController = createScene
    }
    func execute<T>(from scene: T?) where T : UIViewController {
        if let destination = createViewController() {
            scene?.present(destination, animated: true, completion: nil)
        }
    }
}
