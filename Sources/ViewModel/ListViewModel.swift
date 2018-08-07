//
//  ViewModelList.swift
//  Boomerang
//
//  Created by Stefano Mondino on 10/11/16.
//
//

import Foundation
//import ReactiveSwift
//import Result
import RxSwift
import Action
import RxCocoa

private struct AssociatedKeys {
    static var disposeBag = "disposeBag"
}

public protocol ListViewModelType: ViewModelType {
    var dataHolder: ListDataHolderType {get set}
    func reuseIdentifier(for identifier: ListIdentifier, at indexPath: IndexPath) -> String?
    func model (atIndex index: IndexPath) -> ModelType?
    func itemViewModel(fromModel model: ModelType) -> ItemViewModelType?
    func reload()
    
}

public protocol ListViewModelTypeSectionable: ListViewModelType {
    func sectionItemViewModel(fromModel model: ModelType, withType type: String) -> ItemViewModelType?
}

public extension ListViewModelTypeSectionable {
    
    public func sectionItemViewModel(fromModel model: ModelType, withType type: String) -> ItemViewModelType? {
        return self.itemViewModel(fromModel: model)
    }
}
public extension ListViewModelType {
    
    public var isEmpty: Observable<Bool> {
        return self.dataHolder.resultsCount.asObservable().map {$0 == 0}
    }
    
    public func identifier(atIndex index: IndexPath) -> ListIdentifier? {
        return self.viewModel(atIndex: index)?.itemIdentifier
    }
    public func reuseIdentifier(for identifier: ListIdentifier, at indexPath: IndexPath) -> String? {
        return nil
    }
    public func viewModel (atIndex index: IndexPath) -> ItemViewModelType? {
        
        var d = self.dataHolder.viewModels.value
        let vm = d[index]
        if (vm == nil) {
            guard let model: ModelType =  self.dataHolder.modelStructure.value.modelAtIndex(index) else {
                return nil
            }
            let item =  self.itemViewModel(fromModel: model)
            d[index] = item
            self.dataHolder.viewModels.accept(d)
            return item
        }
        return vm
    }
    
    public func itemViewModel(fromModel model: ModelType) -> ItemViewModelType? {
        return model as? ItemViewModelType
    }
    
}

public extension ListViewModelType {

    public func model (atIndex index: IndexPath) -> ModelType? {
        let model = self.dataHolder.modelStructure.value.modelAtIndex(index)
        guard let viewModel = model as? ItemViewModelType else {
            return model
        }
        return viewModel.model
    }
    public func reload() {
        self.dataHolder.reload()
    }
}

public extension ListViewModelType where Self: ViewModelTypeFailable {
    var fail: Observable<ActionError> { return self.dataHolder.reloadAction.errors }
}

public extension ListViewModelType where Self: ViewModelTypeLoadable {
    var loading: Observable<Bool> { return self.dataHolder.reloadAction.executing }
}

public extension ListViewModelType where Self: ViewModelTypeLoadable, Self: ViewModelTypeSelectable {
    var loading: Observable<Bool> {
        return Observable.combineLatest(self.dataHolder.reloadAction.executing, self.selection.executing, resultSelector: { $0 || $1})
        
        //        return self.dataHolder.reloadAction.isExecuting.signal.combineLatest(with: (self.selection.isExecuting.signal ?? Signal<Bool,NoError>.empty) ).map {return $0 || $1}
        
    }
}
public extension ListViewModelType where Self: ViewModelTypeFailable, Self: ViewModelTypeSelectable {
    var fail: Observable<ActionError> {
        return Observable.from([self.dataHolder.reloadAction.errors, self.selection.errors], scheduler: MainScheduler.instance).switchLatest()
    }
}
