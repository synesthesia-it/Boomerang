//
//  UITableViewDataSource.swift
//  Boomerang
//
//  Created by Alberto Bo on 08/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit

public enum TableViewHeaderType: String {
    case header = "boomerang_tableview_header"
    case footer = "boomerang_tableview_footer"
    public var identifier: String {
        return self.rawValue
    }
}

open class TableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate{
    
    public var viewModel: ListViewModelType
    public var dataHolder: DataHolder {
        return viewModel.dataHolder
    }
    private var rootGroup: DataGroup {
        return dataHolder.modelGroup
    }
    public init(viewModel: ListViewModelType) {
        self.viewModel = viewModel
    }
    
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        switch rootGroup.depth {
        case 0: return 0
        case 1: return 1
        default:
            return rootGroup.groups?.count ?? 0
        }
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch rootGroup.depth {
        case 0: return 0
        case 1: return rootGroup.count
        default:
            guard let groups = rootGroup.groups,
                groups.count > section else { return 0 }
            return groups[section].count
        }
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let viewModel: IdentifiableViewModelType = self.viewModel.mainViewModel(at: indexPath),
            let identifier = viewModel.identifier as? ReusableListIdentifier {
            
            let reuseIdentifier = (self.viewModel.identifier(at: indexPath, for: nil) ?? identifier).name
            
            if identifier.shouldBeEmbedded == true {
                
                tableView.register(identifier.containerClass as? UITableViewCell.Type ?? ContentTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
            } else {
                if let className = identifier.class as? UIView.Type {
                    tableView.register(className, forCellReuseIdentifier: reuseIdentifier)
                } else {
                    tableView.register(UINib(nibName: identifier.name, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
                }
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
            (cell as? ViewModelCompatibleType)?.set(viewModel:  viewModel)
            return cell
            
        } else {
            let defaultItemIdentifier = "boomerang_empty_identifier"
            tableView.register(ContentTableViewCell.self, forCellReuseIdentifier: defaultItemIdentifier)
            return tableView.dequeueReusableCell(withIdentifier: defaultItemIdentifier, for: indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return viewModel.canMoveItem(at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel.moveItem(from: sourceIndexPath, to: destinationIndexPath)
    }
    
    
    private func getTableViewSupplementaryView() -> UIView?{
        return nil
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}

extension Boomerang where Base: UITableView{
    var internalDataSource: TableViewDataSource? {
        get {
            return objc_getAssociatedObject(base, &AssociatedKeys.tableViewDataSource) as? TableViewDataSource
        }
        set {
            objc_setAssociatedObject(base, &AssociatedKeys.tableViewDataSource, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
