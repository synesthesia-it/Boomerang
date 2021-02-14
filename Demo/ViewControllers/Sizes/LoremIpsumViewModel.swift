//
//  TestViewModel.swift
//  NewArch
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import UIKit

class LoremIpsumViewModel: ListViewModel, NavigationViewModel {
    var onUpdate: () -> Void = {}
    var sections: [Section] = [] {
        didSet {
            onUpdate()
        }
    }
    var onNavigation: (Route) -> Void = { _ in }

    let layoutIdentifier: LayoutIdentifier
    let uniqueIdentifier: UniqueIdentifier = UUID()
    var downloadTask: Task?
    let routeFactory: RouteFactory
    let itemViewModelFactory: ItemViewModelFactory
    let cellIdentifier: ViewIdentifier
    init(identifier: SceneIdentifier = .schedule,
         itemViewModelFactory: ItemViewModelFactory,
         cellIdentifier: ViewIdentifier = .show,
         routeFactory: RouteFactory) {
        self.layoutIdentifier = identifier
        self.routeFactory = routeFactory
        self.itemViewModelFactory = itemViewModelFactory
        self.cellIdentifier = cellIdentifier
    }

    func reload() {
        self.sections = (0..<10)
            .map { "\($0)" }
            .map { section in
                return Section(id: section, items:
                    (0..<6).map {_ in self.itemViewModelFactory.description(text: Lorem.words(10))}
                               , header: self.itemViewModelFactory.header(title: "Section \(section)"))
        }
    }
    
    func selectItem(at indexPath: IndexPath) {
    }
    func sectionProperties(at index: Int) -> Size.SectionProperties {
        switch index {
        case 0:
            return .init(insets: .zero, lineSpacing: 8, itemSpacing: 8)
        default: return .init(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), lineSpacing: 4, itemSpacing: 4)
        }
    }
    func elementSize(at indexPath: IndexPath, type: String?) -> ElementSize? {
        guard type == nil else { return indexPath.section == 0 ? Size.zero() : nil }
        switch indexPath.section {
        case 0:
            switch indexPath.item {
            case 0: return Size.container()
            default: return Size.aspectRatio(1/2, itemsPerLine: 3)
            }
        case 1:
            return Size.fixed(height: 100)
        case 2: return Size.fixed(height: 100, itemsPerLine: 2)
        case 3: return Size.automatic(itemsPerLine: 2)
        default: return Size.automatic(itemsPerLine: 1)
        }
    }
}
