//
//  PagerViewModel.swift
//  TVMaze
//
//  Created by Andrea De vito on 19/11/21.
//

import Boomerang
//import Core
import RxSwift
//import Style
//import Tabman
import UIKit
import RxBoomerang

class TabBarController: UITabBarController {
    let viewModel: ListViewModel
    let routeFactory: RouteFactory
    var disposeBag = DisposeBag()


    init(viewModel: ListViewModel,
         routeFactory: RouteFactory)
    {
        self.viewModel = viewModel
        self.routeFactory = routeFactory
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let factory = routeFactory
        let configurationClosure = { (sections: [Section]) -> [UIViewController] in
            sections.flatMap {
                $0.items.compactMap { item in
                    let viewController = factory.page(from: item)?.createScene() as? UIViewController
                    viewController?.tabBarItem.title = (item as? PageViewModel)?.pageTitle
                    viewController?.tabBarItem.image = (item as? PageViewModel)?.pageIcon
                    return viewController
                }
            }
        }

        if let rxViewModel = viewModel as? RxListViewModel {
            rxViewModel.sectionsRelay
                .asDriver(onErrorJustReturn: [])
                .map { configurationClosure($0) }
                .drive(onNext: { [weak self] in self?.viewControllers = $0 })
                .disposed(by: disposeBag)
        } else {
            viewModel.onUpdate = { [weak self] in
                _ = configurationClosure(self?.viewModel.sections ?? [])
            }
        }
        viewModel.reload()
    }
}
