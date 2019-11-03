//
//  ContentView.swift
//  SwiftUIDemo
//
//  Created by Stefano Mondino on 01/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import SwiftUI
import Combine
#if !COCOAPODS
import Boomerang
import CombineBoomerang
#endif

extension List where Content == ForEach<[IdentifiableViewModel], String, AnyView>, SelectionValue == IdentifiableViewModel {

    public init(_ data: [Boomerang.Section], factory: SwiftUIViewFactory, selection: Binding<IdentifiableViewModel?>?) {

        let elements = data.toList()
        let content = ForEach(elements, id: \.id, content: factory.view(from:))
        self.init(selection: selection, content: { content })
    }
}
extension List where Content == ForEach<[IdentifiableViewModel], String, AnyView>, SelectionValue == Never {

    public init(_ data: [Boomerang.Section], factory: SwiftUIViewFactory) {

        let elements = data.toList()
        let content = ForEach(elements, id: \.id, content: factory.view(from:))
        self.init(content: { content })
    }
}

extension Array where Element: Boomerang.Section {
    func toList() -> [IdentifiableViewModel] {
        return self
        .flatMap { $0.items
            .compactMap { IdentifiableViewModel(viewModel: $0) }
        }
    }
}
