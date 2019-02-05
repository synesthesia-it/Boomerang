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

extension ViewModelCompatible where Self: UIViewController, ViewModel: InteractionViewModelType {
    public func setupInteraction() {
        self.viewModel?.selection
            .elements
            .asSignal(onErrorJustReturn: .none)
            .asObservable()
            .bind {[weak self] interaction in
                guard let self = self else { return }
                switch interaction {
                case .route(let route): Router.execute(route, from: self)
                default: break
                }
        }.disposed(by: disposeBag)
    }
}
