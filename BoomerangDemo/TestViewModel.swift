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
final class TestViewModel:ListViewModelTypeSectionable, ViewModelTypeSelectable, EditableViewModel {
    
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
        switch model {
        case is Item:
            return TestItemViewModel(model: model as! Item)
        case is Section:
            return TestItemViewModel(model: model as! Section)
        default : return nil
        }
    }
    func sectionItemViewModel(fromModel model: ModelType, withType type: String) -> ItemViewModelType? {
        return TestItemViewModel(model: model as! Section, type:type)
    }
    var listIdentifiers: [ListIdentifier] {
        return ["TestCollectionViewCell", "TestTableViewCell", TestIdentifier.test]
    }
    var sectionIdentifiers : [ListIdentifier] {
        return [HeaderIdentifier(name:"TestHeaderTableViewCell", type:TableViewHeaderType.header.identifier),HeaderIdentifier(name:"TestHeaderTableViewCell", type:TableViewHeaderType.footer.identifier) ]
    }
    func canInsertItem(atIndexPath indexPath: IndexPath) -> Bool {
        return true
    }
    func canMoveItem(atIndexPath indexPath: IndexPath) -> Bool {
        return true
    }
    func moveItem(fromIndexPath from: IndexPath, to: IndexPath) {
        self.dataHolder.modelStructure.value.moveItem(fromIndexPath: from, to: to)
    }
    
}
