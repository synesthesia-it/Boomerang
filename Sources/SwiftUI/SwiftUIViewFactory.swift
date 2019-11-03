//
//  SwiftUIViewFactory.swift
//  SwiftUIBoomerang
//
//  Created by Stefano Mondino on 03/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import SwiftUI
#if !COCOAPODS
import CombineBoomerang
#endif

public protocol SwiftUIViewFactory {
    func view(from wrapper: IdentifiableViewModel) -> AnyView
}

extension Boomerang.Section: Identifiable { }

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
