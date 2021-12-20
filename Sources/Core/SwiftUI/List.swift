//
//  List.swift
//  SwiftUIBoomerang
//
//  Created by Stefano Mondino on 03/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//
#if canImport(SwiftUI)
import SwiftUI
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *)
extension List where Content == ForEach<[Boomerang.Section], String, AnyView>, SelectionValue == IdentifiableViewModel {

    public init(_ sections: [Boomerang.Section],
                factory: SwiftUIViewFactory,
                selection: Binding<IdentifiableViewModel?>?) {

        let content = ForEach(sections) { section in
            section.listView(with: factory)
        }

        self.init(selection: selection, content: { content })
    }
}
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *)
extension Boomerang.Section {

    // Probably a bad idea to wrap everything into AnyView, check problems with recycling cells.
    func listView(with factory: SwiftUIViewFactory) -> AnyView {
        let items = self.items.map { IdentifiableViewModel(viewModel: $0) }

        let content = ForEach(items, id: \.id, content: factory.view(from:))
        let header = self.header?.view(from: factory)
        let footer = self.footer?.view(from: factory)
        if let footer = footer,
            let header = header {

            return AnyView(SwiftUI.Section(header: header,
                                           footer: footer,
                                            content: { content }))
        }
        if let header = header {
            return AnyView(SwiftUI.Section(header: header, content: { content }))
        }
        if let footer = footer {
            return AnyView(SwiftUI.Section(footer: footer, content: { content }))
        }
        return AnyView(SwiftUI.Section { content })
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *)
extension ViewModel {
    func view(from factory: SwiftUIViewFactory) -> AnyView? {
        return factory.view(from: IdentifiableViewModel(viewModel: self))
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension List where Content == ForEach<[IdentifiableViewModel], String, AnyView>, SelectionValue == Never {

    public init(_ data: [Boomerang.Section], factory: SwiftUIViewFactory) {

        let elements = data.toList()
        let content = ForEach(elements, id: \.id, content: factory.view(from:))
        self.init(content: { content })
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Array where Element == Boomerang.Section {
    func toList() -> [IdentifiableViewModel] {
        return self
        .flatMap { $0.items
            .compactMap { IdentifiableViewModel(viewModel: $0) }
        }
    }
}
#endif
