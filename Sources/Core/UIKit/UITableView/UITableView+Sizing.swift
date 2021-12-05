//
//  UICollectionView+Sizing.swift
//  Boomerang
//
//  Created by Stefano Mondino on 26/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//
#if os(iOS) || os(tvOS)
import Foundation
import UIKit

public protocol TableViewHeightCalculator {
    func heightForItem(at indexPath: IndexPath,
                     in collectionView: UITableView,
                     type: String?) -> CGFloat
}
#endif
