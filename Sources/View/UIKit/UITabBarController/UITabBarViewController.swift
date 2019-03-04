//
//  PagerViewController.swift
//  App
//
//  Created by Stefano Mondino on 10/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public protocol WithScenePageConfiguration {
    func configure(scene: (Scene & ViewModelCompatibleType), with viewModel: PageViewModelType ) -> Scene
}

public extension UITabBarController {

    public func defaultPageConfiguration(for scene: (Scene & ViewModelCompatibleType), with viewModel: PageViewModelType ) -> Scene {
        let nav = UINavigationController(rootViewController: scene)
        viewModel.pageImage.asDriver(onErrorJustReturn: UIImage()).drive(nav.tabBarItem.rx.image).disposed(by: scene.disposeBag)
        viewModel.selectedPageImage.asDriver(onErrorJustReturn: UIImage()).drive(nav.tabBarItem.rx.selectedImage).disposed(by: scene.disposeBag)
        viewModel.pageTitle.asDriver(onErrorJustReturn: "").drive(nav.tabBarItem.rx.title).disposed(by: scene.disposeBag)
        return nav
    }
}

extension Boomerang where Base: UITabBarController & ViewModelCompatible {
    public func configure(with viewModel: ListViewModelType) {
        viewModel.updates
            .asDriver(onErrorJustReturn: .none)
            .drive(base.rx.dataUpdates(with: viewModel))
            .disposed(by: base.disposeBag)
    }

}

extension Reactive where Base: UITabBarController & ViewModelCompatible {
    
    func dataUpdates(with viewModel: ListViewModelType) -> Binder<DataHolderUpdate> {
        return Binder(base) { base, updates in
            switch updates {
            case .reload(let reload):
                
                let indexes = reload()
                let viewModels = indexes.compactMap {
                    viewModel.mainViewModel(at: $0) as? PageViewModelType
                }
                let viewControllers = viewModels.compactMap { vm -> UIViewController? in
                    if let vc = (vm.sceneIdentifier.scene() as? (UIViewController & ViewModelCompatibleType)) {
                        vc.loadViewAndSet(viewModel: vm)
                        return (base as? WithScenePageConfiguration)?.configure(scene: vc, with: vm) ?? vc
                    }
                    return nil
                }
                base.setViewControllers(viewControllers, animated: true)
            default: break
            }
            
        }
    }
}

public extension Reactive where Base: UITabBarItem {
    public var title: Binder<String> {
        return Binder(base) { base, text in base.title = text }
    }
    public var image: Binder<UIImage> {
        return Binder(base) { base, image in base.image = image }
    }
    public var selectedImage: Binder<UIImage> {
        return Binder(base) { base, image in base.selectedImage = image }
    }
}
