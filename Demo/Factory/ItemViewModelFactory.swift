//
//  ViewModelFactory.swift
//  Demo
//
//  Created by Stefano Mondino on 20/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

protocol ItemViewModelFactory {
    func description(text: String) -> ViewModel
    func header(title: String) -> ViewModel
    func episode(_ episode: Episode, identifier: ViewIdentifier) -> ViewModel
}

struct DefaultItemViewModelFactory: ItemViewModelFactory {
    let container: AppDependencyContainer

    func header(title: String) -> ViewModel {
        return HeaderViewModel(title: title)
    }
    func description(text: String) -> ViewModel {
        return HeaderViewModel(title: text, identifier: .clearHeader)
    }

    func episode(_ episode: Episode, identifier: ViewIdentifier) -> ViewModel {
        return ShowViewModel(episode: episode, identifier: identifier)
    }
}
