//
//  DataSource.swift
//  Boomerang
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit

open class DefaultCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    public typealias Select = (IndexPath) -> ()
    
    public let viewModel: ListViewModel
    public let dataSource: DefaultCollectionViewDataSource
    
    public let selectAction: Select
    
    public init(viewModel: ListViewModel,
                dataSource: DefaultCollectionViewDataSource,
                onSelect selectAction: @escaping Select) {
        self.viewModel = viewModel
        self.dataSource = dataSource
        self.selectAction = selectAction
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectAction(indexPath)
    }
    
}
