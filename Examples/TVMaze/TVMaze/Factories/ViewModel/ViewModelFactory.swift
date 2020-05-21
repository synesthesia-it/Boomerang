//
//  SceneViewModelFactory.swift
//  TVMaze
//
//  Created by Stefano Mondino on 21/05/2020.
//  Copyright © 2020 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

protocol ViewModelFactory {
    var scenes: SceneViewModelFactory { get }
    var items: ItemViewModelFactory { get }
}

protocol SceneViewModelFactory {
    func menu() -> MenuViewModel
}

protocol ItemViewModelFactory {
    func menu(item: MenuItem) -> ViewModel
}
