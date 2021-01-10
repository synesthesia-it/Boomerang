//
//  DynamicCollectionViewSizeCalculator.swift
//  CoreUI
//
//  Created by Stefano Mondino on 10/01/21.
//
#if canImport(UIKit)
import Foundation
import UIKit

open class DynamicSizeCalculator: BaseCollectionViewSizeCalculator {
    func sectionProperties(in section: Int) -> Size.SectionProperties? {
        viewModel.sectionProperties(at: section)
    }
    public init(
        viewModel: ListViewModel,
        factory: CollectionViewCellFactory) {
        super.init(viewModel: viewModel, factory: factory, defaultSize: .zero)
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
        guard let elementSize = viewModel.elementSize(at: indexPath, type: type) else {
           return automaticSizeForItem(at: indexPath, in: collectionView, direction: direction, type: type)
        }
        let direction = direction ?? Direction.from(layout: collectionView.collectionViewLayout)
        let fixedDimension = calculateFixedDimension(for: direction,
                                                     collectionView: collectionView,
                                                     at: indexPath,
                                                     itemsPerLine: (elementSize as? GridElementSize)?.itemsPerLine ?? 1)
        let bounds = boundingBox(for: collectionView)

        let parameters = Size.ContainerProperties(containerBounds: bounds,
                                                         maximumWidth: direction == .horizontal ? nil : fixedDimension,
                                                         maximumHeight: direction == .vertical ? nil : fixedDimension)
        guard let size = elementSize.size(for: parameters) else {
            return automaticSizeForItem(at: indexPath, in: collectionView, direction: direction, type: type)
        }
        return size
    }
}
#endif
