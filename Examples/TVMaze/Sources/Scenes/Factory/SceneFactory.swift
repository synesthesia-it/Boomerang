//
//  SceneFactory.swift
//  TVMaze
//
//  Created by Andrea De vito on 22/10/21.
//

import Foundation
import Boomerang
import UIKit

protocol SceneFactory {
    func schedule () -> UIViewController
    func showDetail (viewModel: ShowDetailViewModel) -> UIViewController
    func showCastDetail(view: ShowCastDetailViewModel) -> UIViewController
    func showSeasonDetail(view: ShowSeasonDetailViewModel) -> UIViewController
    func search (viewModel: SearchViewModel) -> UIViewController
    func mainTabBar() -> UIViewController
}

class SceneFactoryImplementation : SceneFactory{
    
    let container : AppContainer
    
    
    init(container : AppContainer){
        self.container = container
    }
    func schedule () -> UIViewController{
        let viewModel = container.sceneViewModels.scheduleViewModel()
        return ScheduleViewController(nibName: name(from: viewModel),
                                      viewModel: viewModel,
                                      components: container.components)
    }
    
    func showDetail (viewModel: ShowDetailViewModel) -> UIViewController{
        return ShowDetailViewController(viewModel: viewModel,
                                        components: container.components)
    }
    
    func showCastDetail (view viewModel: ShowCastDetailViewModel) -> UIViewController{
        return ShowCastDetailViewController(viewModel: viewModel,
                                            components: container.components)
    }
    
    
    func showSeasonDetail(view viewModel: ShowSeasonDetailViewModel) -> UIViewController {
        return ShowSeasonDetailViewController(viewModel: viewModel,
                                              components: container.components)
    }
    
    
    func search(viewModel: SearchViewModel) -> UIViewController {
        return SearchViewController(viewModel: viewModel,
                                    components: container.components)
    }
    
    private func name (from viewModel: ViewModel) -> String{
        viewModel
            .layoutIdentifier
            .identifierString.capitalized + "ViewController"
    }
    
    func mainTabBar() -> UIViewController {
        let viewModel = container.sceneViewModels.homePager()
        return TabBarController(viewModel: viewModel, routeFactory: container.routes)
        
    }

}
