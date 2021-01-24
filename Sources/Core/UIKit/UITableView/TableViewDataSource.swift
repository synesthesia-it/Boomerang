//
//  DataSource.swift
//  Boomerang
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

#if canImport(UIKit)
import Foundation
import UIKit

open class TableViewDataSource: NSObject, UITableViewDataSource {
    public var viewModel: ListViewModel
    public var factory: TableViewCellFactory
    public init(viewModel: ListViewModel, factory: TableViewCellFactory) {
        self.viewModel = viewModel
        self.factory = factory
    }

    open func numberOfSections(in tableView: UITableView) -> Int {
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
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        self.tableView(tableView, viewForHeaderFooterInSection: section, kind: Section.Supplementary.header)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        self.tableView(tableView, viewForHeaderFooterInSection: section, kind: Section.Supplementary.footer)
    }
    
    private func tableView(_ tableView: UITableView, viewForHeaderFooterInSection section: Int, kind: String) -> UIView? {
        let indexPath = IndexPath(item: 0, section: section)
        guard let viewModel = viewModel
            .sections[section]
                .supplementary.item(atIndex: indexPath.item, forKind: kind) else {
            return nil
        }
        let name = factory.name(from: viewModel.layoutIdentifier)
        tableView.register(factory.headerFooterCellClass(from: viewModel.layoutIdentifier), forHeaderFooterViewReuseIdentifier: name)
        guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: name) else {
            return nil
        }
        factory.configureCell(cell, with: viewModel)
        return cell
    }
    
   
//    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
//        viewModel.canMoveItem(at: indexPath)
//    }
//    public func collectionView(_ collectionView: UICollectionView,
//                               moveItemAt sourceIndexPath: IndexPath,
//                               to destinationIndexPath: IndexPath) {
//        viewModel.moveItem(at: sourceIndexPath, to: destinationIndexPath)
//    }

}

#endif
