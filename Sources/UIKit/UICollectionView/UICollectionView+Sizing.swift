//
//  UICollectionView+Sizing.swift
//  Boomerang
//
//  Created by Stefano Mondino on 26/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit

public enum Direction {
    case horizontal
    case vertical
    
    public static func from(layout: UICollectionViewLayout) -> Direction {
        guard let flow = layout as? UICollectionViewFlowLayout else { return .vertical }
        switch flow.scrollDirection {
        case .horizontal: return .horizontal
        case .vertical: return .vertical
        @unknown default: return .vertical
        }
    }
}

public protocol CollectionViewSizeCalculator {
    func insets(for collectionView: UICollectionView, in section: Int) -> UIEdgeInsets
    func itemSpacing(for collectionView: UICollectionView, in section: Int) -> CGFloat
    func lineSpacing(for collectionView: UICollectionView, in section: Int) -> CGFloat
    func sizeForItem(at indexPath: IndexPath,in collectionView: UICollectionView, direction: Direction?, type: String?) -> CGSize
}

public extension CollectionViewSizeCalculator {
    private func flow(for collectionView: UICollectionView) -> UICollectionViewFlowLayout? {
        return collectionView.collectionViewLayout as? UICollectionViewFlowLayout
    }
    private func delegate(for collectionView: UICollectionView) -> UICollectionViewDelegateFlowLayout? {
        return collectionView.delegate as? UICollectionViewDelegateFlowLayout
    }
    
    func boundingBox(for collectionView: UICollectionView) -> CGSize {
        return CGSize(width: collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right,
                      height: collectionView.bounds.height - collectionView.contentInset.top - collectionView.contentInset.top)
    }
    
    func calculateFixedDimension(for direction: Direction,
                                        collectionView: UICollectionView,
                                        at indexPath: IndexPath,
                                        itemsPerLine: Int,
                                        type: String? = nil) -> CGFloat {
        
        let collectionViewSize = boundingBox(for: collectionView)
        if type == UICollectionView.elementKindSectionHeader || type == UICollectionView.elementKindSectionFooter {
            switch direction {
            case .vertical:
                return collectionViewSize.width
            case .horizontal:
                return collectionViewSize.height
            }
        }
        let itemsPerLine = CGFloat(itemsPerLine)
        let insets = self.insets(for: collectionView, in: indexPath.section)
        let itemSpacing = self.itemSpacing(for: collectionView, in: indexPath.section)
        let spacingDiff = (itemsPerLine - 1) * itemSpacing
        let value: CGFloat
        switch direction {
        case .vertical:
            value = (collectionViewSize.width - insets.left - insets.right - spacingDiff) / itemsPerLine
        case .horizontal:
            value = (collectionViewSize.height - insets.top - insets.bottom - spacingDiff) / itemsPerLine
        }
        return floor(floor(value * UIScreen.main.scale)/UIScreen.main.scale)
    }
    
}
