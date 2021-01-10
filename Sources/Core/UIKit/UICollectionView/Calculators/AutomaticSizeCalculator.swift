//
//  AutomaticSizeCalculator.swift
//  Boomerang
//
//  Created by Stefano Mondino on 13/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//
#if canImport(UIKit)
import UIKit

open class AutomaticCollectionViewSizeCalculator: BaseCollectionViewSizeCalculator {

    public typealias Size = (UICollectionView, IndexPath, String?) -> CGSize
    public typealias Spacing = (UICollectionView, Int) -> CGFloat
    public typealias Insets = (UICollectionView, Int) -> UIEdgeInsets

    private lazy var _insets: Insets = { _, _ in
        return .zero
    }

    private lazy var _lineSpacing: Spacing = { _, _ in
        return 0
    }
    private lazy var _itemSpacing: Spacing = { _, _ in
        return 0
    }

    open func withLineSpacing(lineSpacing: @escaping Spacing) -> Self {
        self._lineSpacing = lineSpacing
        return self
    }
    open func withItemSpacing(itemSpacing: @escaping Spacing) -> Self {
        self._itemSpacing = itemSpacing
        return self
    }

    open func withInsets(insets: @escaping Insets) -> Self {
        self._insets = insets
        return self
    }

    public init(
        viewModel: ListViewModel,
        factory: CollectionViewCellFactory,
        itemsPerLine: Int = 1) {
        super.init(viewModel: viewModel,
                   factory: factory,
                   itemsPerLine: itemsPerLine,
                   defaultSize: .zero)
    }

    open override func sizeForItem(at indexPath: IndexPath,
                                   in collectionView: UICollectionView,
                                   direction: Direction? = nil,
                                   type: String? = nil) -> CGSize {

        return automaticSizeForItem(at: indexPath, in: collectionView, direction: direction, type: type)
    }

    open override func insets(for collectionView: UICollectionView, in section: Int) -> UIEdgeInsets {
        self._insets(collectionView, section)
    }

    open override func itemSpacing(for collectionView: UICollectionView, in section: Int) -> CGFloat {
        self._itemSpacing(collectionView, section)
    }

    open override func lineSpacing(for collectionView: UICollectionView, in section: Int) -> CGFloat {
        self._lineSpacing(collectionView, section)
    }

}
#endif
