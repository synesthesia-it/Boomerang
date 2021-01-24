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

open class TableViewDelegate: NSObject, UITableViewDelegate {
    public typealias Select = (IndexPath) -> Void
    private weak var dataSource: TableViewDataSource?
    
    public init(heightCalculator: TableViewHeightCalculator,
                dataSource: TableViewDataSource) {
        self.dataSource = dataSource
        self.heightCalculator = heightCalculator
    }

    private var didSelect: Select = { _ in }
    private var didDeselect: Select = { _ in }

    public let heightCalculator: TableViewHeightCalculator

    open func withSelect(select: @escaping Select) -> Self {
        self.didSelect = select
        return self
    }

    open func withDeselect(deselect: @escaping Select) -> Self {
        self.didDeselect = deselect
        return self
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        dataSource?.tableView(tableView, viewForHeaderInSection: section)
    }
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        dataSource?.tableView(tableView, viewForFooterInSection: section)
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelect(indexPath)
    }
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.didDeselect(indexPath)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        heightCalculator.heightForItem(at: IndexPath(item: 0, section: section),
                                     in: tableView,
                                     type: Section.Supplementary.header)
        
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        heightCalculator.heightForItem(at: IndexPath(item: 0, section: section),
                                     in: tableView,
                                     type: Section.Supplementary.footer)
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        heightCalculator.heightForItem(at: indexPath, in: tableView, type: nil)
    }
    
}

#endif
