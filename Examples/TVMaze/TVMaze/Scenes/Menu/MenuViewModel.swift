//
//  MenuViewModel.swift
//  TVMaze
//
//  Created by Stefano Mondino on 21/05/2020.
//  Copyright © 2020 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

enum MenuItem: String, CaseIterable {
    case schedule
    case search
}
class MenuViewModel: ListViewModel, NavigationViewModel {

    var onNavigation: (Route) -> Void = { _ in }

    var sections: [Section] = [] {
        didSet { onUpdate() }
    }

    var onUpdate: () -> Void = {}

    let uniqueIdentifier: UniqueIdentifier = UUID()

    let layoutIdentifier: LayoutIdentifier
    let routeFactory: RouteFactory
    let itemFactory: ItemViewModelFactory

    init(layoutIdentifier: LayoutIdentifier = SceneIdentifier.menu,
         itemFactory: ItemViewModelFactory,
         routeFactory: RouteFactory) {
        self.layoutIdentifier = layoutIdentifier
        self.routeFactory = routeFactory
        self.itemFactory = itemFactory
    }

    func reload() {
        let items = MenuItem.allCases.map(itemFactory.menu(item:))
        self.sections = [Section(items:items)]

    }

    func selectItem(at indexPath: IndexPath) {

        if let item = self[indexPath]?.get(on: MenuItemViewModel.self, from: \.item) {
            onNavigation(routeFactory.sideMenu(from: item))
        }
    }
}


extension ViewModel {
    func get<Source, Value>(on type: Source.Type,
                            from keyPath: KeyPath<Source, Value>) -> Value? {
        guard let cast = self as? Source else { return nil }
        return cast[keyPath: keyPath]
    }
}
