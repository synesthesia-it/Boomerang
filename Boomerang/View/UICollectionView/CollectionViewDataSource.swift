//
//  CollectionViewDataSource.swift
//  Boomerang
//
//  Created by Stefano Mondino on 20/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit

open class CollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    public var viewModel: ListViewModelType
    public var dataHolder: DataHolder {
        return viewModel.dataHolder
    }
    private var rootGroup: DataGroup {
        return dataHolder.modelGroup
    }
    public init(viewModel: ListViewModelType) {
        self.viewModel = viewModel
    }
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch rootGroup.depth {
        case 0: return 0
        case 1: return 1
        default:
            return rootGroup.groups?.count ?? 0
        }
    }
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch rootGroup.depth {
        case 0: return 0
        case 1: return rootGroup.count
        default:
            guard let groups = rootGroup.groups,
                groups.count > section else { return 0 }
            return groups[section].count
        }
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let viewModel: IdentifiableViewModelType = self.viewModel.supplementaryViewModel(at: indexPath, for: kind) as? IdentifiableItemViewModelType {
            let identifier = viewModel.identifier
            let reuseIdentifier = (self.viewModel.identifier(at: indexPath, for: kind) ?? identifier).name
            
            if (identifier as? ReusableListIdentifier)?.shouldBeEmbedded == true {
                collectionView.register(ContentCollectionViewCell.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
            } else {
                if let className = (identifier as? ReusableListIdentifier)?.className as? UIView.Type {
                    collectionView.register(className, forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
                } else {
                    collectionView.register(UINib(nibName: identifier.name, bundle: nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
                }
            }
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath)
            (cell as? ViewModelCompatibleType)?.set(viewModel:  viewModel)
            return cell
        } else {
            let defaultItemIdentifier = "boomerang_empty_identifier"
            collectionView.register(ContentCollectionViewCell.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: defaultItemIdentifier)
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: defaultItemIdentifier, for: indexPath)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return viewModel.canMoveItem(at: indexPath)
    }
    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel.moveItem(from: sourceIndexPath, to: destinationIndexPath)
    }
}

extension Boomerang where Base: UICollectionView {
    var internalDataSource: CollectionViewDataSource? {
        get {
            return objc_getAssociatedObject(base, &AssociatedKeys.collectionViewDataSource) as? CollectionViewDataSource
        }
        set {
            objc_setAssociatedObject(base, &AssociatedKeys.collectionViewDataSource, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
