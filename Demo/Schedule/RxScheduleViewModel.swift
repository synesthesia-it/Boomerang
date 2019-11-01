//
//  TestViewModel.swift
//  NewArch
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import RxBoomerang
import RxSwift
import RxRelay

class RxScheduleViewModel: ItemViewModel, RxListViewModel, NavigationViewModel {

    let sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])
    var onNavigation: (Route) -> () = { _ in }
    
    let layoutIdentifier: LayoutIdentifier

    var downloadTask: Task?
    let disposeBag = DisposeBag()
    init(identifier: SceneIdentifier = .schedule) {
        self.layoutIdentifier = identifier
        
        downloadTask = URLSession.shared.getEntity([Episode].self, from: .schedule) {[weak self] result in
            switch result {
            case .success(let episodes):
                self?.sections = [Section(id: "Schedule", items: episodes.map { ShowItemViewModel(episode: $0)})]
            case .failure(let error):
                print(error)
            }
        }
        
        Observable<Int>.interval(.seconds(2), scheduler: MainScheduler.instance)
        
            .bind{ _ in
                let sections = self.sections
                sections.forEach { $0.items.shuffle() }
                self.sections = sections
        }
            .disposed(by: disposeBag)
            
    }
        
    func selectItem(at indexPath: IndexPath) {
        if let viewModel = self[indexPath] as? ShowItemViewModel {
            onNavigation(NavigationRoute(viewModel: ShowDetailViewModel(show: viewModel.show)))
        }
    }
}

