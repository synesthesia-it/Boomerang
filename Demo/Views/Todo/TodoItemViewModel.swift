//
//  TodoItemViewModel.swift
//  Demo
//
//  Created by Andrea Bellotto on 18/05/2020.
//  Copyright © 2020 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import UIKit

class TodoViewModel: ViewModel {
    var uniqueIdentifier: UniqueIdentifier
    var layoutIdentifier: LayoutIdentifier
    
    var todo: String
    
    init(todo: Todo, identifier: ViewIdentifier = .todo) {
        self.layoutIdentifier = identifier
        self.todo = todo.todo
        self.uniqueIdentifier = self.todo + "\(todo.id)"
    }
    
}
