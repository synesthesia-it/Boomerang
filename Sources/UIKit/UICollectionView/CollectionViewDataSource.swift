//
//  DataSource.swift
//  Boomerang
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit

open class DefaultCollectionViewDataSource: NSObject, UICollectionViewDataSource {
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
}
