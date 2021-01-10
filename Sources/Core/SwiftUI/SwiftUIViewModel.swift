//
//  SwiftUIViewModel.swift
//  CombineBoomerang
//
//  Created by Stefano Mondino on 03/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//
#if canImport(SwiftUI)
import Foundation
import Combine
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension ViewModel where Self: ObservableObject, Self.ObjectWillChangePublisher == ObservableObjectPublisher {
    func update() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
}
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension ListViewModel where Self: ObservableObject,
                                     Self.ObjectWillChangePublisher == ObservableObjectPublisher {
    var onUpdate: () -> Void {
        get { return {[weak self] in self?.update() }}
        // swiftlint:disable unused_setter_value
        set {}
    }
}
#endif
