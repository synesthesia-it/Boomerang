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
        
        typealias KindMap = [String: ViewModel]
        
        internal var items: [Int: KindMap] = [:]
        
        mutating public func set(_ viewModel: ViewModel, withKind kind: String, atIndex index: Int) {
            var kindMap = self.items[index] ?? [:]
            kindMap[kind] =  viewModel
            self.items[index] = kindMap
        }
        
        public func item(atIndex index: Int, forKind kind: String) -> ViewModel? {
            return items[index]?[kind]
        }
    }
    public var id: String
    public var items: [ViewModel]
    public var supplementary: Supplementary

    public init(
        id: String = "",
        items: [ViewModel],
        supplementary: Supplementary? = nil) {
        self.id = id
        self.items = items
        let supplementary = supplementary ?? Supplementary()
        self.supplementary = supplementary
    }
}
