//
//  AppDelegate.swift
//  NewArch
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
//    let container = DefaultAppDependencyContainer()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let viewController = GameScreenViewController(viewModel: StateGameScreenViewModel(),
                                                      viewFactory: CellFactory())
        window.rootViewController = UINavigationController(rootViewController: viewController)
        window.makeKeyAndVisible()
        
//        container
//            .routeFactory
//            .restartRoute()
//            .execute(from: UIViewController())

        return true
    }
}
