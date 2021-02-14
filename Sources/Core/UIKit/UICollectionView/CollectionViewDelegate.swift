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

open class CollectionViewDelegate: NSObject, UICollectionViewDelegate {
    public typealias Select = (IndexPath) -> Void

    public init(sizeCalculator: CollectionViewSizeCalculator) {

        self.sizeCalculator = sizeCalculator
    }

    private var didSelect: Select = { _ in }
    private var didDeselect: Select = { _ in }

    public let sizeCalculator: CollectionViewSizeCalculator

    open func withSelect(select: @escaping Select) -> Self {
        self.didSelect = select
        return self
    }

    open func withDeselect(deselect: @escaping Select) -> Self {
        self.didDeselect = deselect
        return self
    }

    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelect(indexPath)
    }
    open func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.didDeselect(indexPath)
    }
}
extension CollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    open func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeCalculator.sizeForItem(at: indexPath, in: collectionView, direction: nil, type: nil)
    }
    open func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             referenceSizeForHeaderInSection section: Int) -> CGSize {
        return sizeCalculator.sizeForItem(at: IndexPath(item: 0, section: section),
                                          in: collectionView,
                                          direction: nil,
                                          type: UICollectionView.elementKindSectionHeader)
    }
    open func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             referenceSizeForFooterInSection section: Int) -> CGSize {
        return sizeCalculator.sizeForItem(at: IndexPath(item: 0, section: section),
                                          in: collectionView,
                                          direction: nil,
                                          type: UICollectionView.elementKindSectionFooter)
    }

    open func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             insetForSectionAt section: Int) -> UIEdgeInsets {
        return sizeCalculator.insets(for: collectionView, in: section)
    }

    open func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sizeCalculator.lineSpacing(for: collectionView, in: section)
    }

    open func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sizeCalculator.itemSpacing(for: collectionView, in: section)
    }
}
#endif
