//
//  Routes+ViewController.swift
//  Boomerang
//
//  Created by Stefano Mondino on 05/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Boomerang
import UIKit

extension ViewModelCompatibleType where Self: UIViewController {
    func loadViewAndSet(viewModel: ViewModelType) {
        self.rx
            .methodInvoked(#selector(UIViewController.viewDidLoad))
            .map { _ in true }
            .startWith(isViewLoaded)
            .filter { $0 }
            .take(1)
            .asSignal(onErrorJustReturn: false)
            .emit(onNext: {[weak self] _ in
                self?.set(viewModel: viewModel)
            })
            .disposed(by: disposeBag)
    }
}
