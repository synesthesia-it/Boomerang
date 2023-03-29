//
//  AppDelegate.swift
//  NewArch
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit
import Combine

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        let cellFactory = CellFactory()

        let stateViewController = UINavigationController(rootViewController:
                                                            DiffableGameScreenViewController(viewModel: StateGameScreenViewModel(),
                                                                                     viewFactory: cellFactory))

        window.rootViewController = stateViewController
        window.makeKeyAndVisible()

        return true
    }
    
    @Published var sections: [String] = []
    var cancellables: [AnyCancellable] = []
    func test() {
        print(sections)
        $sections.sink { print($0) }.store(in: &cancellables)
        sections = ["pluto"]
    }
}
