//
//  ViewModelFactory.swift
//  Boomerang
//
//  Created by Stefano Mondino on 13/11/16.
//
//

import Foundation
import Boomerang

struct ViewModelFactory {
    static func cats() -> ViewModelType {
        return CatsViewModel()
    }
    static func catItem(with model:Cat) -> ItemViewModelType {
        return CatItemViewModel(model:model)
    }
}

