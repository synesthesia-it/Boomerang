//
//  ViewControllerFactory.swift
//  TVMaze
//
//  Created by Stefano Mondino on 21/05/2020.
//  Copyright © 2020 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
import Boomerang
import Pax

typealias Scene = UIViewController

struct ViewControllerFactory: SceneFactory {

    let container: AppDependencyContainer

    private func name(from layoutIdentifier: LayoutIdentifier) -> String {
        let identifier = layoutIdentifier.identifierString
        return identifier.prefix(1).uppercased() + identifier.dropFirst() + "ViewController"
    }


    func root() -> Scene {
        let pax = Pax()
        pax.setMainViewController(UIViewController())
        let menu = self.menu()
        menu.pax.menuWidth = 250
        pax.setViewController(menu, at: .left)

        return pax
    }

    func menu() -> Scene {
        let viewModel = container.viewModels.scenes.menu()
        let cellFactory = UICollectionViewCellFactory(viewFactory: UIViewFactory())
        return MenuViewController(nibName: name(from: viewModel.layoutIdentifier),
                                  viewModel: viewModel,
                                  collectionViewCellFactory: cellFactory)
    }

    
//MURRAY IMPLEMENTATION PLACEHOLDER

}
