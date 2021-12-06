//
//  NavigationRoute.swift
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

struct NavigationRoute : UIKitRoute{
    var createViewController: () -> UIViewController?
    
    func execute<T: UIViewController>(from scene: T?){
        if let nav = scene?.navigationController,
           let controller = createViewController() {
            nav.pushViewController(controller, animated: true)
        }
    }
}
