//
//  SceneViewModelFactoryImplementation.swift
//  TVMaze
//
//  Created by Stefano Mondino on 21/05/2020.
//  Copyright © 2020 Synesthesia. All rights reserved.
//

import Foundation

struct SceneViewModelFactoryImplementation: SceneViewModelFactory {
    
    let container: AppDependencyContainer
    
    func menu() -> MenuViewModel {
        return MenuViewModel(itemFactory: container.viewModels.items,
                             routeFactory: container.routeFactory)
    }    
    
    
    
    func schedule() -> ShowsViewModel {
        ShowsViewModel(itemViewModelFactory: container.viewModels.items,
                       title: "Tonight's Schedule",
                      useCase: container.useCases.schedule,
                      routeFactory: container.routeFactory)
    }
    
    func credits(for person: Person) -> ShowsViewModel {
        ShowsViewModel(itemViewModelFactory: container.viewModels.items,
                       title: person.name + " - Credits",
                      useCase: PersonsShows(person: person),
                      routeFactory: container.routeFactory)
    }

    
    func search() -> SearchViewModel {
        SearchViewModel(itemViewModelFactory: container.viewModels.items,
                        useCase: container.useCases.search,
                        routeFactory: container.routeFactory)
    }
    
    
    //MURRAY IMPLEMENTATION PLACEHOLDER
}
