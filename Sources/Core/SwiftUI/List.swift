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

#if !os(watchOS)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
extension List where SelectionValue: ViewModel {
    public init<Factory>(_ sections: [Boomerang.Section],
                         factory: Factory,
                         selection: Binding<SelectionValue?>?)
    where Factory: SwiftUIViewFactory, Content == AnyView {
        let content = ForEach(sections) { section in
                section.listView(with: factory)
        }
        self.init(selection: selection, content: { AnyView(content) })
    }
}
#endif
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *)
extension List where SelectionValue == Never {

    public init<Factory: SwiftUIViewFactory>(_ sections: [Boomerang.Section],
                         factory: Factory) where Content == AnyView {
        let content = ForEach(sections) { section in
            section.listView(with: factory)
        }
        self.init(content: { AnyView(content) })
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *)
extension Boomerang.Section {
    
    // Probably a bad idea to wrap everything into AnyView, check problems with recycling cells.
    func listView<Factory: SwiftUIViewFactory>(with factory: Factory) -> AnyView {
        let items = self.items

        let content = ForEach(items, id: \.uniqueIdentifier.stringValue, content: factory.view(from:))
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
//
    @available(watchOS, unavailable)
    func listView<Factory: SwiftUIViewFactory>(with factory: Factory,
                                               header: Factory.View,
                                               items: [ViewModel]) -> SwiftUI.Section< Factory.View, ForEach<[ViewModel], String, Factory.View>, EmptyView> {
        let content = ForEach(items,
                              id: \.uniqueIdentifier.stringValue,
                              content: factory.view(from:))
        return SwiftUI.Section(header: header,
                               content: { content })
    }
    @available(watchOS, unavailable)
    func listView<Factory: SwiftUIViewFactory>(with factory: Factory,
                                               footer: Factory.View,
                                               items: [ViewModel]) -> SwiftUI.Section<EmptyView, ForEach<[ViewModel], String, Factory.View>, Factory.View> {
        let content = ForEach(items,
                              id: \.uniqueIdentifier.stringValue,
                              content: factory.view(from:))
        return SwiftUI.Section(footer: footer,
                               content: { content })
    }
    @available(watchOS, unavailable)
    func listView<Factory: SwiftUIViewFactory>(with factory: Factory,
                                               header: Factory.View,
                                               footer: Factory.View,
                                               items: [ViewModel]) -> SwiftUI.Section<Factory.View, ForEach<[ViewModel], String, Factory.View>,  Factory.View> {
        let content = ForEach(items,
                              id: \.uniqueIdentifier.stringValue,
                              content: factory.view(from:))
        return SwiftUI.Section(header: header,
                               footer: footer,
                               content: { content })
    }
    @available(watchOS, unavailable)
    func listView<Factory: SwiftUIViewFactory>(with factory: Factory,
                                               items: [ViewModel]) -> SwiftUI.Section<EmptyView, ForEach<[ViewModel], String, Factory.View>, EmptyView> {
        let content = ForEach(items,
                              id: \.uniqueIdentifier.stringValue,
                              content: factory.view(from:))
        return SwiftUI.Section(content: { content })
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *)
extension ViewModel {
    func view<Factory: SwiftUIViewFactory>(from factory: Factory) -> Factory.View? {
        return factory.view(from: self)
    }
}

#endif
