//
//  CollectionView+Rx.swift
//  RxBoomerang
//
//  Created by Stefano Mondino on 01/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
#if !COCOAPODS
import Boomerang
#endif

#if os(iOS) || os(tvOS)
public extension Reactive where Base: UICollectionView {
    
    func reloaded(by viewModel: RxListViewModel,
                  dataSource collectionViewDataSource: CollectionViewDataSource) -> Disposable {

        let reloadDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<Section, ViewModel>>(
            configureCell: { (_, cv, indexPath, _) -> UICollectionViewCell in
                return collectionViewDataSource.collectionView(cv, cellForItemAt: indexPath)
        }, configureSupplementaryView: { _, cv, kind, indexPath in
            collectionViewDataSource.collectionView(cv, viewForSupplementaryElementOfKind: kind, at: indexPath)
        })

        return viewModel.sectionsRelay
            .asDriver()
            .map { $0.map { SectionModel(model: $0, items: $0.items) }}
            .drive(items(dataSource: reloadDataSource))
    }
    
    func animated(by viewModel: RxListViewModel,
                  dataSource collectionViewDataSource: CollectionViewDataSource) -> Disposable {

        let reloadDataSource = RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<Section, IdentifiableViewModel>>(
            configureCell: { (_, cv, indexPath, _) -> UICollectionViewCell in
                return collectionViewDataSource.collectionView(cv, cellForItemAt: indexPath)
        },
            configureSupplementaryView: { _, cv, kind, indexPath in
                collectionViewDataSource.collectionView(cv, viewForSupplementaryElementOfKind: kind, at: indexPath)
        })
        return viewModel.sectionsRelay
            .asDriver()
            .map { $0.map { AnimatableSectionModel(model: $0, items: $0.items.map { IdentifiableViewModel(viewModel: $0)}) }}
            .drive(items(dataSource: reloadDataSource))
    }
}
#endif
