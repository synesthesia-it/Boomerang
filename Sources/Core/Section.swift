//
//  Section.swift
//  Boomerang
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public class Section {

    public struct Supplementary {
        static let header = "internal_header_type"
        static let footer = "internal_footer_type"
        typealias KindMap = [String: ViewModel]

        internal var items: [Int: KindMap] = [:]

        mutating public func set(_ viewModel: ViewModel, withKind kind: String, atIndex index: Int) {
            var kindMap = self.items[index] ?? [:]
            kindMap[kind] =  viewModel
            self.items[index] = kindMap
        }
        mutating public func set(header viewModel: ViewModel) {
            self.set(viewModel, withKind: Section.Supplementary.header, atIndex: 0)
        }
        mutating public func set(footer viewModel: ViewModel) {
            self.set(viewModel, withKind: Section.Supplementary.footer, atIndex: 0)
        }
        public func item(atIndex index: Int, forKind kind: String) -> ViewModel? {
            return items[index]?[kind]
        }
    }
    public var id: String
    public var items: [ViewModel]
    public var supplementary: Supplementary
    public var header: ViewModel? {
        return supplementary.item(atIndex: 0, forKind: Supplementary.header)
    }
    public var footer: ViewModel? {
        return supplementary.item(atIndex: 0, forKind: Supplementary.footer)
    }
    public init(
        id: String = "",
        items: [ViewModel] = [],
        header: ViewModel? = nil,
        footer: ViewModel? = nil,
        supplementary: Supplementary? = nil) {
        self.id = id
        self.items = items
        var supplementary = supplementary ?? Supplementary()
        if let header = header {
            supplementary.set(header: header)
        }
        if let footer = footer {
            supplementary.set(footer: footer)
        }
        self.supplementary = supplementary
    }
}
