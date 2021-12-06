//
//  RestartRoute.swift
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

struct RestartRoute : UIKitRoute{
    var createViewController: () -> UIViewController?
    
    func execute<T: UIViewController>(from scene: T?){
        let scene = scene ?? UIApplication.shared.delegate?.window??.rootViewController

                if let presented = scene?.presentedViewController {
                    execute(from: presented)
                    return
                }

                if let presenting = scene?.presentingViewController {
                    scene?.dismiss(animated: false) {
                        self.execute(from: presenting)
                    }
                    return
                }

                UIApplication.shared.delegate?.window??.rootViewController = createViewController()
                UIApplication.shared.delegate?.window??.makeKeyAndVisible()
        }
    }
