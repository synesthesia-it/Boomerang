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
    func schedule() -> ShowsViewModel
    func credits(for person: Person) -> ShowsViewModel
    func search() -> SearchViewModel
    //MURRAY SCENE
}

protocol ItemViewModelFactory {
    func menu(item: MenuItem) -> ViewModel
    func show(_ show: Show, hideTitle: Bool) -> ViewModel
    func person(_ person: Person) -> ViewModel
    func header(_ header: String) -> ViewModel
    //MURRAY ITEM
}
