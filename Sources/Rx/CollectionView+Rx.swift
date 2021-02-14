//
//  CollectionView+Rx.swift
//  RxBoomerang
//
//  Created by Stefano Mondino on 01/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//
#if os(iOS) || os(tvOS)
import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
#if !COCOAPODS
import Boomerang
#endif

public extension Reactive where Base: UICollectionView {

    func reloaded(by viewModel: RxListViewModel,
                  dataSource collectionViewDataSource: CollectionViewDataSource) -> Disposable {

        let data = RxCollectionViewSectionedReloadDataSource<SectionModel<Section, ViewModel>>(
            configureCell: { (_, collectionView, indexPath, _) -> UICollectionViewCell in
                return collectionViewDataSource.collectionView(collectionView,
                                                               cellForItemAt: indexPath)
        }, configureSupplementaryView: { _, collectionView, kind, indexPath in
            collectionViewDataSource.collectionView(collectionView,
                                                    viewForSupplementaryElementOfKind: kind,
                                                    at: indexPath)
        })

        return viewModel.sectionsRelay
            .asDriver()
            .map { $0.map { SectionModel(model: $0, items: $0.items) }}
            .drive(items(dataSource: data))
    }

    func animated(by viewModel: RxListViewModel,
                  dataSource collectionViewDataSource: CollectionViewDataSource) -> Disposable {

        let data = RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<Section, UniqueViewModelWrapper>>(
            configureCell: { (_, collectionView, indexPath, _) -> UICollectionViewCell in
                return collectionViewDataSource.collectionView(collectionView, cellForItemAt: indexPath)
        },
            configureSupplementaryView: { _, collectionView, kind, indexPath in
                collectionViewDataSource.collectionView(collectionView,
                                                        viewForSupplementaryElementOfKind: kind,
                                                        at: indexPath)
        })
        return viewModel.sectionsRelay
            .asDriver()
            .map { $0
                .map { AnimatableSectionModel(model: $0, items: $0.items.map { UniqueViewModelWrapper(viewModel: $0)}) }
        }
            .drive(items(dataSource: data))
    }

    func dragAndDrop() -> Disposable {
        let gesture = UILongPressGestureRecognizer()
        base.addGestureRecognizer(gesture)
        return gesture.rx.event.bind {[weak base] gesture in
            guard let base = base else { return }
            switch gesture.state {
            case .began:
                guard let selectedIndexPath = base.indexPathForItem(at: gesture.location(in: base)) else {
                    break
                }
                base.beginInteractiveMovementForItem(at: selectedIndexPath)
            case .changed:
                base.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view ?? base))
            case .ended:
                base.endInteractiveMovement()
            default:
                base.cancelInteractiveMovement()
            }
        }

    }
}
#endif
