//
//  CollectionViewCellFactory.swift
//  Boomerang
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
/**
    Defines how collection view cells should be generated so they can be used inside  a collection view
 */
public protocol CollectionViewCellFactory: ViewFactory {
    var defaultCellIdentifier: String { get }
    func cellClass(from itemIdentifier: LayoutIdentifier?) -> UICollectionViewCell.Type
    func configureCell(_ cell: UICollectionViewCell, with viewModel: ItemViewModel)
}
