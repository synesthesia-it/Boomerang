//
//  RxListViewModel.swift
//  Demo
//
//  Created by Stefano Mondino on 20/05/2020.
//  Copyright © 2020 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
#if !COCOAPODS_RXBOOMERANG
import Boomerang
#endif
public protocol RxListViewModel: ListViewModel, RxViewModel {
    var sectionsRelay: BehaviorRelay<[Section]> { get }
}

public extension RxListViewModel {
    var sections: [Section] {
        get {
            sectionsRelay.value
        }
        set {
            sectionsRelay.accept(newValue)
        }
    }
    var onUpdate: () -> Void {
        get { return {} }
        // swiftlint:disable unused_setter_value
        set { }
    }
}

public extension Reactive where Base: RxListViewModel {
    var sections: Observable<[Section]> {
        return base.sectionsRelay.asObservable()
    }
}
