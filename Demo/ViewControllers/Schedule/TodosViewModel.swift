//
//  TodoViewModel.swift
//  Demo
//
//  Created by Andrea Bellotto on 18/05/2020.
//  Copyright © 2020 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

class TodosViewModel: ListViewModel, NavigationViewModel {
    func selectItem(at indexPath: IndexPath) {
        print("selected item")
    }
    
    var onUpdate: () -> Void = {}
    
    var sections: [Section] = [] {
        didSet {
            onUpdate()
        }
    }
    
    var onNavigation: (Route) -> Void = { _ in }
    
    var layoutIdentifier: LayoutIdentifier
    var uniqueIdentifier: UniqueIdentifier
    var routeFactory: RouteFactory
    let itemViewModelFactory: ItemViewModelFactory
//    var downloadTask: Task?

    init(identifier: SceneIdentifier = .todo,
         itemViewModelFactory: ItemViewModelFactory,
         routeFactory: RouteFactory) {
        self.layoutIdentifier = identifier
        self.routeFactory = routeFactory
        self.itemViewModelFactory = itemViewModelFactory
        self.uniqueIdentifier = UUID().uuidString
    }

    func reload() {
        let factory = itemViewModelFactory
        let todos = (0..<20).map({ Todo(todo:$0.description) }).map({ factory.todo($0) })
        self.sections = [Section(id: "1", items: todos) ]
        
    }
}



struct Todo {
    var id: UUID
    var todo: String
    
    init(id: UUID = UUID(), todo: String) {
        self.id = id
        self.todo = todo
    }
}
