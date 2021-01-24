//
//  DynamicCollectionViewSizeCalculator.swift
//  CoreUI
//
//  Created by Stefano Mondino on 10/01/21.
//
#if canImport(UIKit)
import Foundation
import UIKit

open class DynamicHeightCalculator: BaseTableViewHeightCalculator {

    public init(
        viewModel: ListViewModel,
        factory: TableViewCellFactory) {
        super.init(viewModel: viewModel, factory: factory, defaultHeight: .zero)
    }

    open func sectionProperties(in section: Int) -> Size.SectionProperties? {
        viewModel.sectionProperties(at: section)
    }
    public override func heightForItem(at indexPath: IndexPath,
                                       in tableView: UITableView,
                                       type: String?) -> CGFloat {
        let type = type?.toSectionKind()
        guard let elementSize = viewModel.elementSize(at: indexPath, type: type) else {
            return autoHeightForItem(at: indexPath, in: tableView, type: type)
        }
        
    
        let bounds = tableView.bounds.size
        let parameters = Size.ContainerProperties(containerBounds: bounds,
                                                        maximumWidth: bounds.width,
                                                         maximumHeight:nil)
        guard let height = elementSize.size(for: parameters)?.height else {
            return autoHeightForItem(at: indexPath, in: tableView, type: type)
        }
        return height
    }
}
#endif
