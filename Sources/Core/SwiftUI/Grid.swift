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

@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
extension LazyVGrid {
    public init<Factory: SwiftUIViewFactory>(_ data: [Boomerang.Section],
                columns: [GridItem],
                alignment: HorizontalAlignment = .center,
                spacing: CGFloat? = nil,
                pinnedViews: PinnedScrollableViews = .init(),
                                             factory: Factory)
    where Content == ForEach<[Section], String, AnyView>  {

        let content = ForEach(data) { section in
                section.listView(with: factory)
        }
        
        self.init(columns: columns,
                  alignment: alignment,
                  spacing: spacing,
                  pinnedViews: pinnedViews,
                  content: { content })
    }
}

@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
extension LazyHGrid {
    public init<Factory: SwiftUIViewFactory>(_ data: [Boomerang.Section],
                                             rows: [GridItem],
                alignment: VerticalAlignment = .center,
                spacing: CGFloat? = nil,
                pinnedViews: PinnedScrollableViews = .init(),
                                             factory: Factory)
    where Content == ForEach<[Section], String, AnyView>  {

        let content = ForEach(data) { section in
                section.listView(with: factory)
        }
        
        self.init(rows: rows,
                  alignment: alignment,
                  spacing: spacing,
                  pinnedViews: pinnedViews,
                  content: { content })
    }
}
#endif
