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

//@available(macOS 10.15, iOS 14.0, tvOS 14.0, *)
//@available(watchOS, unavailable)
//extension LazyVGrid where Content == ForEach<[Boomerang.Section], String, AnyView> {
//
//    public init(_ sections: [Boomerang.Section],
//                columns: [GridItem],
//                factory: SwiftUIViewFactory) {
//
//        let content = ForEach(sections) { section in
//            section.listView(with: factory)
//        }
//
//        self.init(columns: columns, content: { content })
//    }
//}

//@available(macOS 10.15, iOS 14.0, tvOS 14.0, *)
//@available(watchOS, unavailable)
//extension LazyHGrid where Content == ForEach<[Boomerang.Section], String, AnyView> {
//
//    public init(_ sections: [Boomerang.Section],
//                rows: [GridItem],
//                factory: SwiftUIViewFactory) {
//
//        let content = ForEach(sections) { section in
//            section.listView(with: factory)
//        }
//
//        self.init(rows: rows, content: { content })
//    }
//}

@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
extension LazyVGrid where Content == ForEach<[IdentifiableViewModel], String, AnyView> {

    public init(_ data: [Boomerang.Section],
                columns: [GridItem],
                alignment: HorizontalAlignment = .center,
                spacing: CGFloat? = nil,
                pinnedViews: PinnedScrollableViews = .init(),
                factory: SwiftUIViewFactory) {

        let elements = data.toList()
        
        let content = ForEach(elements, id: \.id, content: factory.view(from:))
        self.init(columns: columns,
                  alignment: alignment,
                  spacing: spacing,
                  pinnedViews: pinnedViews,
                  content: { content })
    }
}

@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
extension LazyHGrid where Content == ForEach<[IdentifiableViewModel], String, AnyView> {

    public init(_ data: [Boomerang.Section],
                rows: [GridItem],
                alignment: VerticalAlignment = .center,
                spacing: CGFloat? = nil,
                pinnedViews: PinnedScrollableViews = .init(),
                factory: SwiftUIViewFactory) {

        let elements = data.toList()
        
        let content = ForEach(elements, id: \.id, content: factory.view(from:))
        
        self.init(rows: rows,
                  alignment: alignment,
                  spacing: spacing,
                  pinnedViews: pinnedViews,
                  content: { content })
    }
}
#endif
