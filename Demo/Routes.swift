//
//  Routes.swift
//  Boomerang
//
//  Created by Stefano Mondino on 05/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import UIKit

struct MainRoute: ViewModelRoute {
    var viewModel: SceneViewModelType
}

extension Router {
    
    
    static func bootstrap() {
        register(MainRoute.self) { route, _ in
            guard let controller = route.destination else {
                fatalError("No root controller found. Please check your routes")
            }
            (controller as? UIViewController & ViewModelCompatibleType)?.loadViewAndSet(viewModel: route.viewModel)
            let destination = UINavigationController(rootViewController:controller)
            UIApplication.shared.delegate?.window??.rootViewController = destination
        }
        
        register(NavigationRoute.self) { route, source in
            guard let destination = route.destination else {
                return
            }
            (destination as? UIViewController & ViewModelCompatibleType)?.loadViewAndSet(viewModel: route.viewModel)
            source?.navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    static func start() {
        bootstrap()
//        self.execute(MainRoute(viewModel: ScheduleViewModel()), from: nil)
        self.execute(MainRoute(viewModel: ScheduleViewModel()), from: nil)
    }
}
