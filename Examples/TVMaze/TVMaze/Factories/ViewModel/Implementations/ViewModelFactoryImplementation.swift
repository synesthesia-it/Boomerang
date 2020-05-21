//
//  ViewModelFactoryImplementation.swift
//  TVMaze
//
//  Created by Stefano Mondino on 21/05/2020.
//  Copyright © 2020 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

class AppViewModelFactory: ViewModelFactory, DependencyContainer {
    enum Keys: CaseIterable, Hashable {
        case scenes
        case items
    }
    var scenes: SceneViewModelFactory { self[.scenes] }
    var items: ItemViewModelFactory { self[.items] }
    let container = Container<Keys>()

    init(container: AppDependencyContainer) {
        self.register(for: .scenes) { SceneViewModelFactoryImplementation(container: container) }
        self.register(for: .items) { ItemViewModelFactoryImplementation(container: container) }
    }
}
