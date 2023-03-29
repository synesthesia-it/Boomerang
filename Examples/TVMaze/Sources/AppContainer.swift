//
//  AppContainer.swift
//  TVMaze
//
//  Created by Andrea De vito on 22/10/21.
//

import Foundation
import Boomerang

class AppContainer: DependencyContainer {

    enum Keys: String {
        case routes
        case components
        case componentViewModels
        case scenes
        case sceneViewModels
        case useCases
    }

    let container: Container<DependencyKey> = .init()

    typealias DependencyKey = Keys
    var routes: RouteFactory { self[.routes] }
    var components: ComponentFactory {self[.components]}
    var componentViewModels: ComponentViewModelFactory {self[.componentViewModels]}
    var scenes: SceneFactory {self[.scenes]}
    var sceneViewModels: SceneViewModelFactory {self[.sceneViewModels]}
    var useCases: UseCaseContainer {self[.useCases]}

    init() {
//        self.routes = RouteFactoryImplementation(container: self)
//        self.components = ComponentViewModelFactoryImplementations()
        register(for: .routes, scope: .singleton ) {
            RouteFactoryImplementation(container: self)
        }
        register(for: .components, scope: .singleton ) {
            ComponentFactoryImplementation()
        }
        register(for: .componentViewModels, scope: .singleton ) {
            ComponentViewModelFactoryImplementation(container: self)
        }
        register(for: .scenes, scope: .singleton ) {
            SceneFactoryImplementation(container: self)
        }
        register(for: .sceneViewModels, scope: .singleton ) {
            SceneViewModelFactoryImplementations(container: self, useCaseContainer: UseCaseContainer())
        }
        register(for: .useCases, scope: .singleton ) {
            UseCaseContainer()
        }
    }
}
