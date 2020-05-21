//
//  RxListViewModel.swift
//  RxBoomerang
//
//  Created by Stefano Mondino on 01/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

#if !COCOAPODS
@_exported import Boomerang
#endif

#if !canImport(Differentiator)
public protocol IdentifiableType {
    associatedtype Identity: Hashable
    var identity: Identity { get }
}
#else
import Differentiator
#endif

public protocol RxViewModel: ViewModel {
    var disposeBag: DisposeBag { get }
}

extension Section: IdentifiableType {
    public var identity: String {
        return self.id
    }
}

struct IdentifiableViewModel: IdentifiableType, Equatable {
    static func == (lhs: IdentifiableViewModel, rhs: IdentifiableViewModel) -> Bool {
        lhs.identity == rhs.identity
    }

    var viewModel: ViewModel
    var identity: String {
        return viewModel.uniqueIdentifier.stringValue
    }
}
