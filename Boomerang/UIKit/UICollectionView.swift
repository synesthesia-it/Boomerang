//
//  UICollectionView.swift
//  Boomerang
//
//  Created by Stefano Mondino on 02/11/16.
//
//

import UIKit


//extension UICollectionReusableView : ViewModelBindable {
//
//}


private class ViewModelCollectionViewDataSource : NSObject, UICollectionViewDataSource {
    weak var viewModel: ViewModelListType?
    init (viewModel: ViewModelListType) {
        super.init()
        self.viewModel = viewModel
        
    }
    @objc public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell  {
        let viewModel:ViewModelItemType? = self.viewModel?.viewModelAtIndex(indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel?.itemIdentifier.name ?? defaultListIdentifier, for: indexPath)
        (cell as? ViewModelBindable)?.bindViewModel(viewModel)
        return cell
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count =  self.viewModel?.models.value.children?.count ?? 1
        return count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count =  self.viewModel?.models.value.children?[section].models?.count
        count =  count ?? self.viewModel?.models.value.models?.count
        return count ?? 0
    }
    
    @objc public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let model = self.viewModel?.models.value.children?[indexPath.section].sectionModel
        if nil != model {
            
            let vm =  self.viewModel?.itemViewModel(model!)
            if (vm != nil) {
                let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: vm!.itemIdentifier.name, for: indexPath)
                (cell as? ViewModelBindable)?.bindViewModel(vm)
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    
}

public protocol ViewModelListTypeHeaderable : ViewModelListType {
    func headerIdentifiers() -> [ListIdentifier]
}

public extension ViewModelListType  {
    var collectionViewDataSource:UICollectionViewDataSource {
        return ViewModelCollectionViewDataSource(viewModel: self)
    }
    
    public func listIdentifiers() -> [ListIdentifier] {
        return []
    }
    

}

extension UICollectionView : ViewModelBindable {
    public func bindViewModel(_ viewModel: ViewModelType?) {
        guard let vm = viewModel as? ViewModelListType else {
            return
        }
        
        let collectionView = self
        _ = vm.listIdentifiers().map { $0.name}.reduce("", { (_, value) in
            collectionView.register(UINib(nibName: value, bundle: nil), forCellWithReuseIdentifier: value)
            return ""
        })
        _ = (vm as? ViewModelListTypeHeaderable)?.headerIdentifiers().reduce("", { (_, value) in
            
            collectionView.register(UINib(nibName: value.name, bundle: nil), forSupplementaryViewOfKind: value.type ?? UICollectionElementKindSectionHeader, withReuseIdentifier: value.name)
            return ""
        })
        let dataSource = vm.collectionViewDataSource
        self.dataSource = dataSource
      
        vm.resultsCount.producer.startWithResult {[weak self] _ in
            self?.reloadData()
            dataSource
        }
    }
}
