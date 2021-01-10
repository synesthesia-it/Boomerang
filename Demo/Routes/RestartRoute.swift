//
//  RestartRoute.swift
//  Demo
//
//  Created by Stefano Mondino on 08/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKitBoomerang
import UIKit

struct RestartRoute: UIKitRoute {

    let createViewController: () -> UIViewController?
    init(createScene: @escaping () -> UIViewController) {
        self.createViewController = createScene
    }

    func execute<T: UIViewController>(from scene: T?) {

        // TODO Dismiss all modals
        UIApplication.shared.delegate?.window??.rootViewController = createViewController()
        UIApplication.shared.delegate?.window??.makeKeyAndVisible()
    }

    init(viewModel: ScheduleViewModel,
         factory: ViewControllerFactory) {

        self.createViewController = {

            return factory.schedule(viewModel: viewModel)

        }
    }
}
