//
//  AutomaticSizeCalculator.swift
//  Boomerang
//
//  Created by Stefano Mondino on 13/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//
#if os(iOS) || os(tvOS)
import UIKit

open class AutomaticTableViewHeightCalculator: BaseTableViewHeightCalculator {

    public typealias Size = (UITableView, IndexPath, String?) -> CGSize

    public init(
        viewModel: ListViewModel,
        factory: TableViewCellFactory) {
        super.init(viewModel: viewModel,
                   factory: factory,
                   defaultHeight: .zero)
    }
    public override func heightForItem(at indexPath: IndexPath, in tableView: UITableView, type: String?) -> CGFloat {
        autoHeightForItem(at: indexPath, in: tableView, type: type)
    }
}
#endif
