//
//  DynamicCollectionViewSizeCalculator.swift
//  CoreUI
//
//  Created by Stefano Mondino on 10/01/21.
//
#if os(iOS) || os(tvOS)
import Foundation
import UIKit

/**
    A size calculator using size informations from associated list view model `ElementSize` properties.
    
    Use this calculator when you can't determine upfront what sizes are needed for each collection view cell, by delegating the task to view model's business logic.
    This is useful when complex lists of data are downloaded from some remote API, defining both data and layout informations. By using delegation to list view model elements, you can accomplish complex layouts with grids, automatic sizing only where needed (improving perfomances) and so on.
 */
open class DynamicSizeCalculator: BaseCollectionViewSizeCalculator {

    public init(
        viewModel: ListViewModel,
        factory: CollectionViewCellFactory) {
        super.init(viewModel: viewModel, factory: factory, defaultSize: .zero)
    }

    open func sectionProperties(in section: Int) -> Size.SectionProperties? {
        viewModel.sectionProperties(at: section)
    }

    override open func insets(for collectionView: UICollectionView, in section: Int) -> UIEdgeInsets {
        sectionProperties(in: section)?.insets ?? super.insets(for: collectionView, in: section)
    }

    override open func lineSpacing(for collectionView: UICollectionView, in section: Int) -> CGFloat {
        sectionProperties(in: section)?.lineSpacing ?? super.lineSpacing(for: collectionView, in: section)
    }

    override open func itemSpacing(for collectionView: UICollectionView, in section: Int) -> CGFloat {
        sectionProperties(in: section)?.itemSpacing ?? super.lineSpacing(for: collectionView, in: section)
    }

    override open func sizeForItem(at indexPath: IndexPath,
                                   in collectionView: UICollectionView,
                                   direction: Direction? = nil,
                                   type: String? = nil) -> CGSize {
        let type = type?.toSectionKind()
        guard let elementSize = viewModel.elementSize(at: indexPath, type: type) else {
           return automaticSizeForItem(at: indexPath, in: collectionView, direction: direction, type: type)
        }
        let direction = direction ?? Direction.from(layout: collectionView.collectionViewLayout)
        let fixedDimension = calculateFixedDimension(for: direction,
                                                     collectionView: collectionView,
                                                     at: indexPath,
                                                     itemsPerLine: (elementSize as? GridElementSize)?.itemsPerLine ?? 1)
//        let bounds = boundingBox(for: collectionView)

        let parameters = Size.ContainerProperties(containerBounds: collectionView.bounds.size,
                                                  containerInsets: collectionView.adjustedContentInset,
                                                  maximumWidth: direction == .horizontal ? nil : fixedDimension,
                                                  maximumHeight: direction == .vertical ? nil : fixedDimension)
        guard let size = elementSize.size(for: parameters) else {
            let lock = LockingSize(direction: direction, value: fixedDimension)
            return autosizeForItem(at: indexPath, type: type, lockedTo: lock)
        }
        return size
    }
}
#endif
