//
//  TableViewCellFactory.swift
//  Boomerang
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//
#if os(iOS) || os(tvOS)
import Foundation
import UIKit

/**
    Defines how table view cells should be generated so they can be used inside a table view
 */
public protocol TableViewCellFactory: ViewFactory {
    var defaultCellIdentifier: String { get }
    func cellClass(from itemIdentifier: LayoutIdentifier?) -> UITableViewCell.Type
    func headerFooterCellClass(from itemIdentifier: LayoutIdentifier?) -> UITableViewHeaderFooterView.Type
    func configureCell(_ cell: UITableViewCell, with viewModel: ViewModel)
    func configureCell(_ cell: UITableViewHeaderFooterView, with viewModel: ViewModel)
    
}
#endif
