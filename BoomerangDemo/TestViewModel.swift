//
//  TestViewModel.swift
//  Boomerang
//
//  Created by Stefano Mondino on 13/11/16.
//
//

import Foundation
import Boomerang
import RxSwift
import Action
enum TestSelection : SelectionInput {
    case item(IndexPath)
}
enum TestSelectionOutput : SelectionOutput {
    case viewModel(ViewModelType)
}
final class TestViewModel:ListViewModelTypeHeaderable, ViewModelTypeSelectable {
    
    lazy var selection:Action<TestSelection, TestSelectionOutput> = Action  { choice in
        switch choice {
        case .item (let indexPath) :
            let model = self.model(atIndex:indexPath)
            if (model == nil) {
                return .just(.viewModel(ViewModelFactory.item(model:model!)))
            }
            
            return .just(.viewModel(ViewModelFactory.item(model:model!)))
        }
    }
    init (data:Observable<ModelStructure>) {
        self.dataHolder = ListDataHolder(data: data)
    }
    var dataHolder: ListDataHolderType = ListDataHolder.empty
    
    func itemViewModel(fromModel model: ModelType) -> ItemViewModelType? {
        
        return TestItemViewModel(model: model as! Item)
    }
    var listIdentifiers: [ListIdentifier] {
        return ["TestCollectionViewCell"]
    }
    var headerIdentifiers : [ListIdentifier] {
        return [HeaderIdentifier(name:"TestCollectionViewCell", type:"UICollectionElementKindSectionHeader")]
    }

}
