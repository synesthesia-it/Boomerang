//
//  TableViewDelegate.swift
//  Boomerang
//
//  Created by Alberto Bo on 11/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

open class TableViewDelegate: NSObject, UITableViewDelegate {
    
    public static var defaultInsets: UIEdgeInsets?
    public static var defaultLineSpacing: CGFloat?
    public static var defaultItemSpacing: CGFloat?
    public static var defaultItemsPerLine: Int = 1
    
    public typealias Size = (UITableView, IndexPath, String?) -> CGFloat
    public typealias Spacing = (UITableView, Int) -> CGFloat
    public typealias Insets = (UITableView, Int) -> UIEdgeInsets
    
    public typealias Select = (IndexPath) -> ()
    
    private var didSelect: Select = { _ in }
    private var didDeselect: Select = { _ in }
    
    
    private var size: Size = { tableView, indexPath, type in
        return tableView.boomerang.automaticSizeForItem(at: indexPath, type: type)
    }
    
    private var insets: Insets = { tableView, section in
        return TableViewDelegate.defaultInsets ?? tableView.separatorInset
    }
    
    private var lineSpacing: Spacing = { tableView, section in
        return TableViewDelegate.defaultLineSpacing ?? 0.0
    }
    
    private var itemSpacing: Spacing = { tableView, section in
        return TableViewDelegate.defaultItemSpacing ?? 0.0
    }
    
    open func with(size: @escaping Size) -> Self {
        self.size = size
        return self
    }
    open func with(lineSpacing: @escaping Spacing) -> Self {
        self.lineSpacing = lineSpacing
        return self
    }
    open func with(itemSpacing: @escaping Spacing) -> Self {
        self.itemSpacing = itemSpacing
        return self
    }
    
    open func with(insets: @escaping Insets) -> Self {
        self.insets = insets
        return self
    }
    open func with(select: @escaping Select) -> Self {
        self.didSelect = select
        return self
    }
    
    open func with(deselect: @escaping Select) -> Self {
        self.didDeselect = deselect
        return self
    }
    
    open func with(itemsPerLine: Int?) -> Self {
        self.size = { tableView, indexPath, type in
            return tableView.boomerang.automaticSizeForItem(at: indexPath, type: type)
        }
        return self
    }
    
    
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.size(tableView, IndexPath(row: 0, section: section), TableViewHeaderType.header.rawValue)
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.size(tableView, IndexPath(row: 0, section: section), TableViewHeaderType.footer.rawValue)
    }

    
    private func getSupplementaryView(for section:Int, tableView: UITableView, type:TableViewHeaderType) -> UIView?{
        
        let indexPath:IndexPath = IndexPath(row: 0, section: section)

        if let ds = tableView.dataSource as? TableViewDataSource,
            let viewModel:IdentifiableViewModelType = ds.viewModel.supplementaryViewModel(at: indexPath, for: type.rawValue){
            
            let identifier:ReusableListIdentifier = viewModel.identifier as! ReusableListIdentifier 
        
            if identifier.shouldBeEmbedded == true{
                tableView.register(identifier.containerClass as? UITableViewHeaderFooterView.Type ?? ContentTableHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: identifier.name)
            }else{
                
                if let className = identifier.class as? UIView.Type {
                    tableView.register(className, forHeaderFooterViewReuseIdentifier: identifier.name)
                } else {
                    tableView.register(UINib(nibName: identifier.name, bundle: nil), forHeaderFooterViewReuseIdentifier: identifier.name)
                }
            }
            
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier.name)
            (view as? ContentTableHeaderFooterView)?.set(viewModel: viewModel)
            return view
        }
        return nil
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return getSupplementaryView(for: section, tableView: tableView, type: .footer)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return getSupplementaryView(for: section, tableView: tableView, type: .header)
    }
    
    
    private func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return size(tableView, indexPath, nil)
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelect(indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.didDeselect(indexPath)
    }
    
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return (tableView.dataSource as? TableViewDataSource)?.viewModel.canMoveItem(at: indexPath) ?? false
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
       (tableView.dataSource as? TableViewDataSource)?.viewModel.moveItem(from: sourceIndexPath, to: destinationIndexPath)
    }

  
//
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            self.tableArray.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
//

}
