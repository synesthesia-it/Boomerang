//
//  DataSource.swift
//  Boomerang
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import Foundation
    import UIKit

    @available(iOS 13.0, tvOS 13.0, *)
    public class TableViewDiffableDataSource: UITableViewDiffableDataSource<Section.ID, String> {
        public var viewModel: ListViewModel
        public var factory: TableViewCellFactory
        public init(tableView: UITableView,
                    viewModel: ListViewModel,
                    factory: TableViewCellFactory) {
            self.viewModel = viewModel
            self.factory = factory
            
            super.init(tableView: tableView) { tableView, indexPath, _ in
                guard let viewModel = viewModel[indexPath] else {
                    
                    tableView.register(factory.cellClass(from: nil),
                                            forCellReuseIdentifier: factory.defaultCellIdentifier)

                    return tableView.dequeueReusableCell(withIdentifier: factory.defaultCellIdentifier,
                                                              for: indexPath)
                }

                let name = factory.name(from: viewModel.layoutIdentifier)
                tableView.register(
                    factory.cellClass(from: viewModel.layoutIdentifier),
                    forCellReuseIdentifier: name)
                let cell = tableView.dequeueReusableCell(withIdentifier: name, for: indexPath)
                factory.configureCell(cell, with: viewModel)
                return cell
            }
        }
        public override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            viewModel.canMoveItem(at: indexPath)
        }
        
        public override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            viewModel.moveItem(at: sourceIndexPath, to: destinationIndexPath)
            super.tableView(tableView, moveRowAt: sourceIndexPath, to: destinationIndexPath)
        }
        
        public override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            if viewModel.canDeleteItem(at: indexPath) {
                return true
            }
            return false
        }
        
        public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return nil
        }
        
        public override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
            return nil
        }
        
        public override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            switch editingStyle {
            case .delete: viewModel.deleteItem(at: indexPath)
            default: break
            }
            super.tableView(tableView, commit: editingStyle, forRowAt: indexPath)
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
    }

    import Combine
    @available(iOS 13.0, tvOS 13.0, *)
    public extension UITableView {
        func animated(by viewModel: any CombineListViewModel,
                      dataSource: TableViewDiffableDataSource) -> AnyCancellable {
            reloaded(by: viewModel, dataSource: dataSource, animated: true)
        }
        
        func reloaded(by viewModel: any CombineListViewModel,
                      dataSource: TableViewDiffableDataSource,
                      animated: Bool = false) -> AnyCancellable {
            viewModel.sectionsSubject
                .sink { sections in
                    var snapshot = NSDiffableDataSourceSnapshot<Section.ID, String>()
                    sections.forEach { section in
                        snapshot.appendSections([section.id])

                        snapshot.appendItems(
                            section.items.map { $0.uniqueIdentifier.stringValue }, toSection: section.id
                        )
                    }
                    dataSource.apply(
                        snapshot,
                        animatingDifferences: animated,
                        completion: nil
                    )
                }
        }
    }
#endif
