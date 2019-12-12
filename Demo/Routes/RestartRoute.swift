//
//  RestartRoute.swift
//  Demo
//
//  Created by Stefano Mondino on 08/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import UIKit

struct RestartRoute: Route {
    
    let createScene: () -> UIViewController?
    init(createScene: @escaping () -> UIViewController) {
        self.createScene = createScene
    }

    func execute<T: Scene>(from scene: T?) {

        //TODO Dismiss all modals
        UIApplication.shared.delegate?.window??.rootViewController = createScene()
        UIApplication.shared.delegate?.window??.makeKeyAndVisible()
    }

    init(viewModel: ScheduleViewModel,
         factory: ViewControllerFactory) {

        self.createScene = {

            return factory.schedule(viewModel: viewModel)

        }
    }
}
