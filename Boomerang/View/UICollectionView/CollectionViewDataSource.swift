//
//  CollectionViewDataSource.swift
//  Boomerang
//
//  Created by Stefano Mondino on 20/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var viewModel: ListViewModelType
    var dataHolder: DataHolder {
        return viewModel.dataHolder
    }
    private var rootGroup: DataGroup {
        return dataHolder.modelGroup
    }
    init(viewModel: ListViewModelType) {
        self.viewModel = viewModel
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch rootGroup.depth {
        case 0:
            return 0
        case 1: return 1
        default:
            return rootGroup.groups?.count ?? 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch rootGroup.depth {
        case 0: return 0
        case 1: return rootGroup.count
        default:
            guard let groups = rootGroup.groups,
                groups.count > section else { return 0 }
            return groups[section].count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let viewModel: IdentifiableViewModelType = self.viewModel.mainViewModel(at: indexPath) as? IdentifiableItemViewModelType {
            let identifier = viewModel.identifier
            let reuseIdentifier = (self.viewModel.identifier(at: indexPath, for: nil) ?? identifier).name
            
            if (identifier as? ReusableListIdentifier)?.shouldBeEmbedded == true {
                collectionView.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
            } else {
                if let className = (identifier as? ReusableListIdentifier)?.className as? UIView.Type {
                    collectionView.register(className, forCellWithReuseIdentifier: reuseIdentifier)
                } else {
                     collectionView.register(UINib(nibName: identifier.name, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
                }
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
            (cell as? ViewModelCompatibleType)?.set(viewModel:  viewModel)
            return cell
        } else {
            let defaultItemIdentifier = "boomerang_empty_identifier"
            collectionView.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: defaultItemIdentifier)
            return collectionView.dequeueReusableCell(withReuseIdentifier: defaultItemIdentifier, for: indexPath)
        }
    }
}

extension Boomerang where Base: UICollectionView {
    var internalDataSource: UICollectionViewDataSource? {
        get {
            return objc_getAssociatedObject(base, &AssociatedKeys.collectionViewDataSource) as? UICollectionViewDataSource
        }
        set {
            return objc_setAssociatedObject(base, &AssociatedKeys.collectionViewDataSource, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
