//
//  DataSource.swift
//  Boomerang
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
#if !COCOAPODS
import Boomerang
#endif
open class TableViewDataSource: NSObject, UITableViewDataSource {
    public var viewModel: ListViewModel
    public var factory: TableViewCellFactory

    public init(viewModel: ListViewModel, factory: TableViewCellFactory) {
        self.viewModel = viewModel
        self.factory = factory
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = self.viewModel[indexPath] else {
            tableView.register(factory.cellClass(from: nil), forCellReuseIdentifier: factory.defaultCellIdentifier)
            return tableView.dequeueReusableCell(withIdentifier: factory.defaultCellIdentifier, for: indexPath)
        }
        
        let name = factory.name(from: viewModel.layoutIdentifier)
        tableView.register(factory.cellClass(from: viewModel.layoutIdentifier), forCellReuseIdentifier: name)
        let cell = tableView.dequeueReusableCell(withIdentifier: name, for: indexPath)
        factory.configureCell(cell, with: viewModel)
        return cell
    }

}

/*
extension String {
    func toSectionKind() -> String {
        switch self {
        case  UICollectionView.elementKindSectionHeader: return Section.Supplementary.header
        case UICollectionView.elementKindSectionFooter:  return Section.Supplementary.footer
        default: return self
        }
    }
    func toCollectionViewKind() -> String {
        switch self {
        case Section.Supplementary.header: return UICollectionView.elementKindSectionHeader
        case Section.Supplementary.footer: return UICollectionView.elementKindSectionFooter
        default: return self
        }
    }
}
*/
