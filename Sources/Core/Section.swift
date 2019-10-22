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
        private var items: [Int: [String: [ItemViewModel]]] = [:]
        init() {
            
        }
    }
    
    public var header: ItemViewModel?
    public var footer: ItemViewModel?
    public var items: [ItemViewModel]
    public init(items: [ItemViewModel],
                header: ItemViewModel? = nil,
                footer: ItemViewModel? = nil) {
        self.items = items
        self.header = header
        self.footer = footer
    }
}
