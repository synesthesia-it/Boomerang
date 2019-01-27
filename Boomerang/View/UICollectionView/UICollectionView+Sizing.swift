//
//  UICollectionView+Sizing.swift
//  Boomerang
//
//  Created by Stefano Mondino on 26/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public enum Direction {
    case horizontal
    case vertical
}
 
extension Boomerang where Base: UICollectionView {
    
    var flow: UICollectionViewFlowLayout? {
        return base.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    var delegate: UICollectionViewDelegateFlowLayout? {
         return base.delegate as? UICollectionViewDelegateFlowLayout
    }
    
    func insets(in section:Int) -> UIEdgeInsets {
        if let flow = flow  {
            return delegate?.collectionView?(base, layout: flow, insetForSectionAt: section) ??
                 flow.sectionInset
        }
        return .zero
    }
    
    func itemSpacing(in section: Int) -> CGFloat {
        if let flow = flow {
            return delegate?.collectionView?(base, layout: flow, minimumInteritemSpacingForSectionAt: section) ?? flow.minimumInteritemSpacing
        }
        return 0
    }
    
    func lineSpacing(in section: Int) -> CGFloat {
        if let flow = flow {
            return delegate?.collectionView?(base, layout: flow, minimumLineSpacingForSectionAt: section) ?? flow.minimumLineSpacing
        }
        return 0
    }
    
    var collectionViewSize: CGSize {
        return CGSize(width: base.bounds.width - base.contentInset.left - base.contentInset.right, height: base.bounds.height - base.contentInset.top - base.contentInset.top)
    }
    
    public func calculateFixedDimension(for direction:Direction, at indexPath: IndexPath, itemsPerLine: Int) -> CGFloat {
        let itemsPerLine = CGFloat(itemsPerLine)
        let insets = self.insets(in: indexPath.section)
        let itemSpacing = self.itemSpacing(in: indexPath.section)
        switch direction {
        case .vertical:
            return (collectionViewSize.width - insets.left - insets.right - (itemsPerLine - 1) * itemSpacing) / itemsPerLine
        case .horizontal:
            return (collectionViewSize.height - insets.top - insets.bottom - (itemsPerLine - 1) * itemSpacing) / itemsPerLine
        }
    }
    
    
}
