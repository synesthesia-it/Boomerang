//
//  Section.swift
//  Boomerang
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public class Section {
    ///TODO implement supplementary items
    public class Supplementary {
        private var items: [Int: [String: [ViewModel]]] = [:]
        init() {
            
        }
    }
    public var id: String
    public var header: ViewModel?
    public var footer: ViewModel?
    public var items: [ViewModel]
    public init(
        id: String = "",
        items: [ViewModel],
        header: ViewModel? = nil,
        footer: ViewModel? = nil) {
        self.id = id
        self.items = items
        self.header = header
        self.footer = footer
    }
}
