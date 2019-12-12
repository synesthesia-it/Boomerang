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
    
    let createScene: () -> UIViewController?
    init(createScene: @escaping () -> UIViewController) {
        self.createScene = createScene
    }
    func execute<T>(from scene: T?) where T : UIViewController {
        if let destination = createScene() {
            scene?.present(destination, animated: true, completion: nil)
        }
    }
}
