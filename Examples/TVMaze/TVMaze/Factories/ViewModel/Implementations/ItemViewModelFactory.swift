//
//  ItemViewModelFactory.swift
//  TVMaze
//
//  Created by Stefano Mondino on 21/05/2020.
//  Copyright © 2020 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

struct ItemViewModelFactoryImplementation: ItemViewModelFactory {

    let container: AppDependencyContainer

    func menu(item: MenuItem) -> ViewModel {
        return MenuItemViewModel(item: item)
    }

    func show(_ show: Show) -> ViewModel {
        ShowItemViewModel(show: show,
                        layoutIdentifier: ItemIdentifier.show)
    }

    
//MURRAY IMPLEMENTATION PLACEHOLDER
}
