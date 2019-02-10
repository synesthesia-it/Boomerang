//
//  CollectionViewDelegate.swift
//  Boomerang
//
//  Created by Stefano Mondino on 10/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit

open class CollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    
    public static var defaultInsets: UIEdgeInsets?
    public static var defaultLineSpacing: CGFloat?
    public static var defaultItemSpacing: CGFloat?
    public static var defaultItemsPerLine: Int?
    
    public typealias Size = (UICollectionView, IndexPath, String?) -> CGSize
    public typealias Spacing = (UICollectionView, Int) -> CGFloat
    public typealias Insets = (UICollectionView, Int) -> UIEdgeInsets
    
    public typealias Select = (IndexPath) -> ()
    
    private var didSelect: Select = { _ in }
    private var didDeselect: Select = { _ in }
    
    
    private var size: Size = { collectionView, indexPath, type in
        guard let items = CollectionViewDelegate.defaultItemsPerLine else {
            return (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize ?? .zero
        }
        return collectionView.boomerang.automaticSizeForItem(at: indexPath, type: type, itemsPerLine: items)
    }
    
    private var insets: Insets = { collectionView, section in
        return CollectionViewDelegate.defaultInsets ?? (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
    }
    
    private var lineSpacing: Spacing = { collectionView, section in
        return CollectionViewDelegate.defaultLineSpacing ?? (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing ?? 0
    }
    private var itemSpacing: Spacing = { collectionView, section in
        return CollectionViewDelegate.defaultItemSpacing ??
            (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0
    }
    
    open func with(size: @escaping Size) -> Self {
        self.size = size
        return self
    }
    open func with(lineSpacing: @escaping Spacing) -> Self {
        self.lineSpacing = lineSpacing
        return self
    }
    open func with(itemSpacing: @escaping Spacing) -> Self {
        self.itemSpacing = itemSpacing
        return self
    }
    
    open func with(insets: @escaping Insets) -> Self {
        self.insets = insets
        return self
    }
    open func with(select: @escaping Select) -> Self {
        self.didSelect = select
        return self
    }
    
    open func with(deselect: @escaping Select) -> Self {
        self.didDeselect = deselect
        return self
    }
    
    open func with(itemsPerLine: Int?) -> Self {
        self.size = { collectionView, indexPath, type in
            guard let itemsPerLine = CollectionViewDelegate.defaultItemsPerLine else {
                return (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize ?? .zero
            }
            return collectionView.boomerang.automaticSizeForItem(at: indexPath, type: type, itemsPerLine: itemsPerLine)
        }
        return self
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return size(collectionView, indexPath, nil)
    }
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return size(collectionView, IndexPath(item: 0, section: section), UICollectionView.elementKindSectionHeader)
    }
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return size(collectionView, IndexPath(item: 0, section: section), UICollectionView.elementKindSectionFooter)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insets(collectionView, section)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing(collectionView, section)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing(collectionView, section)
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelect(indexPath)
    }
    open func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.didDeselect(indexPath)
    }
}
