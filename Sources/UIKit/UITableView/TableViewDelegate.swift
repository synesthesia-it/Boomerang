//
//  DataSource.swift
//  Boomerang
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit

open class TableViewDelegate: NSObject, UITableViewDelegate {
    public typealias Select = (IndexPath) -> Void
        
    private var didSelect: Select = { _ in }
    private var didDeselect: Select = { _ in }
    
    private var rowHeight: CGFloat
    private var estimatedRowHeight: CGFloat
    
    public init( rowHeight: CGFloat = UITableView.automaticDimension, estimatedRowHeight: CGFloat = UITableView.automaticDimension ) {
        self.rowHeight = rowHeight
        self.estimatedRowHeight = estimatedRowHeight
    }
    
    open func withSelect(select: @escaping Select) -> Self {
        self.didSelect = select
        return self
    }
    
    open func withDeselect(deselect: @escaping Select) -> Self {
        self.didDeselect = deselect
        return self
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return estimatedRowHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelect(indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.didDeselect(indexPath)
    }

}
