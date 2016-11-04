//
//  UITableView.swift
//  Boomerang
//
//  Created by Stefano Mondino on 02/11/16.
//
//

import UIKit


private class ViewModelTableViewDataSource : NSObject, UITableViewDataSource {
    weak var viewModel: ViewModelListType?
    init (viewModel: ViewModelListType) {
        super.init()
        self.viewModel = viewModel
        
    }
    
    @objc public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel:ViewModelItemType? = self.viewModel?.viewModelAtIndex(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel?.itemIdentifier.name ?? defaultListIdentifier, for: indexPath)
        (cell as? ViewModelBindable)?.bindViewModel(viewModel)
        return cell
    }
    public func numberOfSections(in tableView: UITableView) -> Int {
        let count =  self.viewModel?.models.value.children?.count ?? 1
        return count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count =  self.viewModel?.models.value.children?[section].models?.count
        count =  count ?? self.viewModel?.models.value.models?.count
        return count ?? 0
    }
    
    
//
//    @objc public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let model = self.viewModel?.models.value.children?[indexPath.section].sectionModel
//        if nil != model {
//            
//            let vm =  self.viewModel?.itemViewModel(model!)
//            if (vm != nil) {
//                let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: vm!.itemIdentifier.name, for: indexPath)
//                (cell as? ViewModelBindable)?.bindViewModel(vm)
//                return cell
//            }
//        }
//        
//        return UICollectionViewCell()
//    }
    
    
}



public extension ViewModelListType  {
    var tableViewDataSource:UITableViewDataSource {
        return ViewModelTableViewDataSource(viewModel: self)
    }
    


}

extension UITableView : ViewModelBindable {
    public func bindViewModel(_ viewModel: ViewModelType?) {
        guard let vm = viewModel as? ViewModelListType else {
            return
        }
        let tableView = self
        _ = vm.listIdentifiers().map { $0.name}.reduce("", { (_, value) in
            tableView.register(UINib(nibName: value.name, bundle: nil), forCellReuseIdentifier: value)
            return ""
        })
        _ = (vm as? ViewModelListTypeHeaderable)?.headerIdentifiers().reduce("", { (_, value) in
            tableView.register(UINib(nibName: value.name, bundle: nil), forHeaderFooterViewReuseIdentifier: value.name)
            return ""
        })
        let dataSource = vm.tableViewDataSource
        self.dataSource = dataSource
      
        vm.resultsCount.producer.startWithResult {[weak self] _ in
            self?.reloadData()
            dataSource
        }
    }
}
