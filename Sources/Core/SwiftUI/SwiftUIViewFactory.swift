//
//  SwiftUIViewFactory.swift
//  SwiftUIBoomerang
//
//  Created by Stefano Mondino on 03/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//
#if canImport(SwiftUI)
import Foundation
import Boomerang
import SwiftUI

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol SwiftUIViewFactory {
    func view(from wrapper: IdentifiableViewModel) -> AnyView
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Boomerang.Section: Identifiable {}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public class IdentifiableViewModel: Identifiable, Equatable, Hashable {
    public let id: String
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    public static func == (lhs: IdentifiableViewModel, rhs: IdentifiableViewModel) -> Bool {
        lhs.id == rhs.id
    }
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
        self.id = viewModel.uniqueIdentifier.stringValue
    }
    public let viewModel: ViewModel

}
#endif
