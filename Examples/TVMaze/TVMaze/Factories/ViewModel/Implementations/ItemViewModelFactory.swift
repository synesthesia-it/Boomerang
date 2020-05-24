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

    func show(_ show: Show, hideTitle: Bool) -> ViewModel {
        ShowItemViewModel(show: show,
                          layoutIdentifier: hideTitle ? ItemIdentifier.show : ItemIdentifier.showWithTitle)
    }

    
    func person(_ person: Person) -> ViewModel {
        PersonItemViewModel(person: person,
                            layoutIdentifier: ItemIdentifier.person)
    }

    
    func header(_ header: String) -> ViewModel {
        HeaderItemViewModel(header: header,
                            layoutIdentifier: ItemIdentifier.header)
    }

    
    //MURRAY IMPLEMENTATION PLACEHOLDER
}
