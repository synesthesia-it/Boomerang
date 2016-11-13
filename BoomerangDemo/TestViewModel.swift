//
//  TestViewModel.swift
//  Boomerang
//
//  Created by Stefano Mondino on 13/11/16.
//
//

import Foundation

import Boomerang


final class TestViewModel:ListViewModelTypeHeaderable {
    
    var dataHolder: ListDataHolderType = ListDataHolder.empty
    
    func itemViewModel(_ model: ModelType) -> ItemViewModelType? {
        return TestItemViewModel(model: model as! Item)
    }
    func listIdentifiers() -> [ListIdentifier] {
        return ["TestCollectionViewCell"]
    }
    func headerIdentifiers() -> [ListIdentifier] {
        return [HeaderIdentifier(name:"TestCollectionViewCell", type:"UICollectionElementKindSectionHeader")]
    }
    func select(selection: SelectionType) -> ViewModelType {
        return  ViewModelFactory.anotherTestViewModel()
    }
}
