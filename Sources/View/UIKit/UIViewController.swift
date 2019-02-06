//
//  UIViewController.swift
//  Boomerang
//
//  Created by Stefano Mondino on 05/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension InteractionCompatible where Self: UIViewController {
    
    public func setupInteraction(with viewModel: InteractionViewModelType) {
            viewModel.selection
                .elements
                .asSignal(onErrorJustReturn: .none)
                .emit(onNext: {[weak self] interaction in
                    guard let self = self else { return }
                    switch interaction {
                    case .route(let route): self.handleInteraction(route)
                    case .custom(let custom): self.handleInteraction(custom)
                    default: self.handleInteraction(interaction)
                    }
                })
                .disposed(by: disposeBag)
        }

    public func handleInteraction(_ route: Route) {
        Router.execute(route, from: self)
    }
    public func handleInteraction(_ custom: CustomInteraction) {
        
    }
    public func handleInteraction(_ interaction: Interaction) {
        
    }
}

extension ViewModelCompatibleType where Self: UIViewController {
    
    public func loadViewAndSet(viewModel: ViewModelType) {
            self.rx
                .methodInvoked(#selector(UIViewController.viewDidLoad))
                .map { _ in true }
                .startWith(isViewLoaded)
                .filter { $0 }
                .take(1)
                .asSignal(onErrorJustReturn: false)
                .emit(onNext: {[weak self] _ in
                    self?.setup(with: viewModel)
                })
                .disposed(by: disposeBag)
    }
    
    func setup(with viewModel:ViewModelType) {
        if let viewModel = viewModel as? InteractionViewModelType {
            (self as? InteractionCompatible)?.setupInteraction(with: viewModel)
        }
        self.set(viewModel: viewModel)
    }
    
}


