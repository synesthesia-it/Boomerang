//
//  TestViewModel.swift
//  Boomerang
//
//  Created by Stefano Mondino on 13/11/16.
//
//

import Foundation
import ReactiveSwift
import Boomerang

enum TestSelection : SelectionInput {
    case item(IndexPath)
}

final class TestViewModel:ListViewModelTypeHeaderable, ViewModelTypeSelectable {
    
    lazy var selection:Action<TestSelection, SelectionOutput, Boomerang.Error> = Action  { choice in
        switch choice {
        case .item (let indexPath) :
            let model = self.modelAtIndex(indexPath)
            if (model == nil) {
                return .empty
            }
            
            return SignalProducer(value:ViewModelFactory.item(model:model!))
        }
    }
    
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

}
