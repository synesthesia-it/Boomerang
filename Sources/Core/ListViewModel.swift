//
//  ListViewModel.swift
//  NewArch
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public protocol ListViewModel: AnyObject {
    var sections: [Section] { get set }
}

public extension ListViewModel {
    subscript(index: IndexPath) -> ItemViewModel? {
        get {
            guard index.count == 2,
                sections.count > index.section,
                sections[index.section].items.count > index.item
                else { return nil }
            return sections[index.section].items[index.item]
        }
    }
}

