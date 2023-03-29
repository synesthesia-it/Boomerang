//
//  AppDelegate.swift
//  TVMaze
//
//  Created by Andrea De vito on 08/10/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
   // let routeFactory : RouteFactory = RouteFactoryImplementation()
    let appContainer: AppContainer = AppContainer()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow(frame: UIScreen.main.bounds)
//        window.rootViewController = UINavigationController(rootViewController: ScheduleViewController(nibName: "ScheduleViewController", bundle: nil))

//        window.rootViewController = UINavigationController(rootViewController: ScheduleViewController(viewModel: ScheduleViewModel()))
//        window.rootViewController = UINavigationController(rootViewController: SearchViewController(viewModel: SearchViewModel()))
        self.window = window
//        window.makeKeyAndVisible()
//        routeFactory
        appContainer
        .routes
        .restart()
        .execute(from: window.rootViewController)
        return true
    }

}
