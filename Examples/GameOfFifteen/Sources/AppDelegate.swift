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

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        let cellFactory = CellFactory()

        let stateViewController = UINavigationController(rootViewController:
                                                            GameScreenViewController(viewModel: StateGameScreenViewModel(),
                                                                                     viewFactory: cellFactory))
        stateViewController.tabBarItem.title = "STATE VM"
        let naiveViewController = UINavigationController(rootViewController:
                                                            GameScreenViewController(viewModel: NaiveGameScreenViewModel(),
                                                                                     viewFactory: cellFactory))
        naiveViewController.tabBarItem.title = "CLASSIC VM"
        let tabController = UITabBarController()

        tabController.viewControllers = [stateViewController, naiveViewController]

        window.rootViewController = tabController
        window.makeKeyAndVisible()

        return true
    }
}
