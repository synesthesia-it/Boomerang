//
//  DataSource.swift
//  Boomerang
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
#if !COCOAPODS
import Boomerang
#endif
open class CollectionViewDataSource: NSObject, UICollectionViewDataSource {
    public var viewModel: ListViewModel
    public var factory: CollectionViewCellFactory
    public init(viewModel: ListViewModel, factory: CollectionViewCellFactory) {
        self.viewModel = viewModel
        self.factory = factory
    }

    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.sections[section].items.count
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = self.viewModel[indexPath] else {
            collectionView.register(factory.cellClass(from: nil), forCellWithReuseIdentifier: factory.defaultCellIdentifier)
            return collectionView.dequeueReusableCell(withReuseIdentifier: factory.defaultCellIdentifier, for: indexPath)
        }

        let name = factory.name(from: viewModel.layoutIdentifier)
        collectionView.register(factory.cellClass(from: viewModel.layoutIdentifier), forCellWithReuseIdentifier: name)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: name, for: indexPath)
        factory.configureCell(cell, with: viewModel)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let viewModel = viewModel
            .sections[indexPath.section]
            .supplementary.item(atIndex: indexPath.item, forKind: kind.toSectionKind()) else {
                collectionView.register(factory.cellClass(from: nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: factory.defaultCellIdentifier)
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: factory.defaultCellIdentifier, for: indexPath)
        }
        let name = factory.name(from: viewModel.layoutIdentifier)
        collectionView.register(factory.cellClass(from: viewModel.layoutIdentifier), forSupplementaryViewOfKind: kind, withReuseIdentifier: name)
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: name, for: indexPath)
        factory.configureCell(cell, with: viewModel)
        return cell
    }
}

extension String {
    func toSectionKind() -> String {
        switch self {
        case  UICollectionView.elementKindSectionHeader: return Section.Supplementary.header
        case UICollectionView.elementKindSectionFooter:  return Section.Supplementary.footer
        default: return self
        }
    }
    func toCollectionViewKind() -> String {
        switch self {
        case Section.Supplementary.header: return UICollectionView.elementKindSectionHeader
        case Section.Supplementary.footer: return UICollectionView.elementKindSectionFooter
        default: return self
        }
    }
}
