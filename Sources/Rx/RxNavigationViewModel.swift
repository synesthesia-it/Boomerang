//
//  RxNavigationViewModel.swift
//  RxBoomerang
//
//  Created by Stefano Mondino on 20/05/2020.
//  Copyright © 2020 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
#if !COCOAPODS
@_exported import Boomerang
#endif

public protocol RxNavigationViewModel: NavigationViewModel {
    var routes: PublishRelay<Route> { get }
}

extension RxNavigationViewModel {
    public var onNavigation: (Route) -> Void {
        get { return {[weak self] in self?.routes.accept($0)} }
        // swiftlint:disable unused_setter_value
        set { }
    }
}
