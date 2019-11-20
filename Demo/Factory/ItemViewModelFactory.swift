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
    func header(title: String) -> ViewModel
    func episode(_ episode: Episode) -> ViewModel
}

struct DefaultItemViewModelFactory: ItemViewModelFactory {
    let container: AppDependencyContainer
    
    func header(title: String) -> ViewModel {
        return HeaderViewModel(title: title)
    }
    
    func episode(_ episode: Episode) -> ViewModel {
        return ShowViewModel(episode: episode)
    }
}
