//
//  RxListViewModel.swift
//  RxBoomerang
//
//  Created by Stefano Mondino on 01/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//
#if canImport(Combine)
import Foundation
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol CombineViewModel: ViewModel {
    var cancellables: [AnyCancellable] { get set }
}
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol CombineNavigationViewModel: NavigationViewModel {
    var routes: PassthroughSubject<Route, Never> { get }
}
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension CombineNavigationViewModel {
    public var onNavigation: (Route) -> Void {
        get { return {[weak self] in self?.routes.send($0)} }
        // swiftlint:disable unused_setter_value
        set { }
    }
}
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol CombineListViewModel: ListViewModel, CombineViewModel {
    var sectionsSubject: CurrentValueSubject<[Section], Never> { get }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
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

// public class AnyCombineViewModel: ObservableObject {
//    public var objectWillChange = ObservableObjectPublisher()
//    public var viewModel: CombineViewModel
//    public init(viewModel: CombineViewModel) {
//        self.viewModel = viewModel
//    }
// }
// public extension CombineListViewModel {
//    func eraseToCombine() -> AnyCombineViewModel {
//        return AnyCombineViewModel(viewModel: self)
//    }
// }
// public class AnyCombineListViewModel: ObservableObject {
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
// }
#endif
