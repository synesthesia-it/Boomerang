//
//  StackView+Rx.swift
//  Demo
//
//  Created by Stefano Mondino on 03/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
#if !COCOAPODS
import Boomerang
#endif

#if os(iOS) || os(tvOS)
public extension Reactive where Base: UIStackView {
    func bind(viewModel: RxListViewModel, factory: ViewFactory) -> Disposable {
        viewModel.sectionsRelay
        .asDriver()
        .drive(onNext: {[weak base] in
            base?.arrangeSections($0, factory: factory)
        })
    }
}
#endif
