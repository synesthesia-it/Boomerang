//
//  TabBarController.swift
//  Boomerang
//
//  Created by Stefano Mondino on 04/03/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
import Boomerang

class MainViewModel: ListViewModelType, SceneViewModelType {
    var sceneIdentifier: SceneIdentifier = Identifiers.Scenes.main
    
    var dataHolder: DataHolder
    
    func convert(model: ModelType, at indexPath: IndexPath, for type: String?) -> IdentifiableViewModelType? {
        return nil
    }
    init() {
        self.dataHolder = DataHolder(data: .just(DataGroup([ScheduleViewModel(), ScheduleViewModel().with(identifier: .scheduleStacked), TableViewScheduleViewModel()])))
    }
    
}

class TabBarController: UITabBarController, ViewModelCompatible {
    func configure(with viewModel: MainViewModel) {
        self.viewModel = viewModel
        self.boomerang.configure(with: viewModel)
        viewModel.load()
    }
    
    var viewModel: MainViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
