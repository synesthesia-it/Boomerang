//
//  DataSource.swift
//  Boomerang
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import Foundation
    import UIKit

    @available(iOS 13.0, tvOS 13.0, *)
    public class CollectionViewDiffableDataSource: UICollectionViewDiffableDataSource<Section.ID, String> {
        public var viewModel: ListViewModel
        public var factory: CollectionViewCellFactory
        public init(collectionView: UICollectionView,
                    viewModel: ListViewModel,
                    factory: CollectionViewCellFactory) {
            self.viewModel = viewModel
            self.factory = factory
            super.init(collectionView: collectionView) { collectionView, indexPath, _ in
                guard let viewModel = viewModel[indexPath] else {
                    collectionView.register(factory.cellClass(from: nil),
                                            forCellWithReuseIdentifier: factory.defaultCellIdentifier)

                    return collectionView.dequeueReusableCell(withReuseIdentifier: factory.defaultCellIdentifier,
                                                              for: indexPath)
                }

                let name = factory.name(from: viewModel.layoutIdentifier)
                collectionView.register(
                    factory.cellClass(from: viewModel.layoutIdentifier),
                    forCellWithReuseIdentifier: name
                )
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: name, for: indexPath)
                factory.configureCell(cell, with: viewModel)
                return cell
            }

            supplementaryViewProvider = { collectionView, kind, indexPath in
                guard let viewModel = viewModel
                    .sections[indexPath.section]
                    .supplementary.item(atIndex: indexPath.item, forKind: kind.toSectionKind()) else {
                    collectionView.register(factory.cellClass(from: nil),
                                            forSupplementaryViewOfKind: kind,
                                            withReuseIdentifier: factory.defaultCellIdentifier)

                    return collectionView
                        .dequeueReusableSupplementaryView(ofKind: kind,
                                                          withReuseIdentifier: factory.defaultCellIdentifier,
                                                          for: indexPath)
                }
                let name = factory.name(from: viewModel.layoutIdentifier)
                collectionView.register(factory.cellClass(from: viewModel.layoutIdentifier),
                                        forSupplementaryViewOfKind: kind,
                                        withReuseIdentifier: name)

                let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: name,
                                                                           for: indexPath)
                factory.configureCell(cell, with: viewModel)
                return cell
            }
        }
    }

    import Combine
    @available(iOS 13.0, tvOS 13.0, *)
    public extension UICollectionView {
        func animated(by viewModel: any CombineListViewModel,
                      dataSource: CollectionViewDiffableDataSource) -> AnyCancellable {
            reloaded(by: viewModel, dataSource: dataSource, animated: true)
        }
        
        func reloaded(by viewModel: any CombineListViewModel,
                      dataSource: CollectionViewDiffableDataSource,
                      animated: Bool = false) -> AnyCancellable {
            viewModel.sectionsSubject
                .sink { sections in
                    var snapshot = NSDiffableDataSourceSnapshot<Section.ID, String>()
                    sections.forEach { section in
                        snapshot.appendSections([section.id])

                        snapshot.appendItems(
                            section.items.map { $0.uniqueIdentifier.stringValue }, toSection: section.id
                        )

                        dataSource.apply(
                            snapshot,
                            animatingDifferences: animated,
                            completion: nil
                        )
                    }
                }
        }
    }
#endif
