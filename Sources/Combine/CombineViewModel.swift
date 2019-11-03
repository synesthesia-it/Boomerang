//
//  RxListViewModel.swift
//  RxBoomerang
//
//  Created by Stefano Mondino on 01/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Combine
#if !COCOAPODS
import Boomerang
#endif

public protocol CombineViewModel: ViewModel {
    var cancellables: [AnyCancellable] { get set }
}

public protocol CombineNavigationViewModel: NavigationViewModel {
    var routes: PassthroughSubject<Route, Never> { get }
}

extension CombineNavigationViewModel {
    public var onNavigation: (Route) -> () {
        get { return {[weak self] in self?.routes.send($0)} }
        set { }
    }
}

public protocol CombineListViewModel: ListViewModel, CombineViewModel {
    var sectionsSubject: CurrentValueSubject<[Section], Never> { get }
}

public extension CombineListViewModel {
    var sections: [Section] {
        get {
            sectionsSubject.value
        }
        set {
            sectionsSubject.send(newValue)
            onUpdate()
        }
    }

}

extension Section: Identifiable { }

public class IdentifiableViewModel: Identifiable, Equatable, Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    public static func == (lhs: IdentifiableViewModel, rhs: IdentifiableViewModel) -> Bool {
        lhs.id == rhs.id
    }
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    public let viewModel: ViewModel

}

//public class AnyCombineViewModel: ObservableObject {
//    public var objectWillChange = ObservableObjectPublisher()
//    public var viewModel: CombineViewModel
//    public init(viewModel: CombineViewModel) {
//        self.viewModel = viewModel
//    }
//}
//public extension CombineListViewModel {
//    func eraseToCombine() -> AnyCombineViewModel {
//        return AnyCombineViewModel(viewModel: self)
//    }
//}
//public class AnyCombineListViewModel: ObservableObject {
//    public var objectWillChange = ObservableObjectPublisher()
//     var viewModel: CombineListViewModel
//    public var sections: [Boomerang.Section] {
//        return viewModel.sections
//    }
//     public init(viewModel: CombineListViewModel) {
//        self.viewModel = viewModel
//        viewModel.onUpdate = {[weak self] in
//            DispatchQueue.main.async {
//                self?.objectWillChange.send()
//            }
//        }
//     }
//}
