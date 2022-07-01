//
//  SwiftUIViewFactory.swift
//  SwiftUIBoomerang
//
//  Created by Stefano Mondino on 03/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//
#if canImport(SwiftUI)
import Foundation
import SwiftUI

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol SwiftUIViewFactory {
    associatedtype View: SwiftUI.View
    func view(from viewModel: ViewModel) -> View
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Boomerang.Section: Identifiable {}
#endif
