//
//  ViewModelList.swift
//  Boomerang
//
//  Created by Stefano Mondino on 10/11/16.
//
//

import Foundation
import RxSwift
import Action
import RxCocoa

private struct AssociatedKeys {
    static var disposeBag = "disposeBag"
}
/**
    A special ViewModel used to handle lists and collections of smaller viewModels
 
    - Discussion:
        Almost all app's screens can be intended as a list of views, each one bound to its specific viewModel.
 
        A ListViewModel acts as a coordinator between a list manager (on iOS, usually a UITableView/UICollectionView, but also more specific components such a MKMapView or custom lists.
 
        It handles list data download/retrieval through associated `ListDataHolderType` and translates each ModelType (one per indexPath) into proper ItemViewModel.
 
        This kind of *translation* between Model and ViewModel is handled lazily, meaning that no ItemViewModel is generated until needed.
 */
public protocol ListViewModelType: ViewModelType {
    /// The `ListDataHolderType` object that will handle model data
    var dataHolder: ListDataHolderType {get set}
    
    /**
     A string identifier that will be used by components with concepts of view reuse/recycle/dequeue (UITableView/UICollectionView/MKMapView) as reuseIdentifer.
     - Discussion:
     Usually, there's no point to specify a custom reuse identifier, as Boomerang internally uses the .xib name or view's class name.
     In this way, tables and collection properly recycle inner cells thus improving performances
     However, there are some cases where this behavior has to be avoided (ex: cells with inner webviews). In this case, providing a custom identifier in combination with custom logic (ex: if current cell is being bound to the same viewModel as before, don't reload the web page) can increase performances or, at least, reduce unwanted behaviors.
    */
    func reuseIdentifier(for identifier: ListIdentifier, at indexPath: IndexPath) -> String?
    
    /**
     Returns current model at provided indexPath
     - Note:
     This method is slightly different from the one from `ListDataHolderType`.
     If the modelStructure contains an ItemViewModelType object at provided indexPath, its inner model is returned instead.
     To obtain the exact modelStructure content, explore it with lower-level accessor methods (ex: `self.dataHolder.modelStructure.value.model(atIndex:indexPath)`
    */
    func model (atIndex index: IndexPath) -> ModelType?
    
    /**
     Converts a `ModelType` object into an `ItemViewModelType`
     
     - Parameters:
        - model: a `ModelType` object to be converted into proper ItemViewModel
     
    Example:
     ```
     func itemViewModel(fromModel model: ModelType) -> ItemViewModelType? {
        switch model {
            case let product as Product: return ProductItemViewModel(model:product)
            case let user as User: return UserItemViewModel(model:user)
            default: return model as? ItemViewModelType
        }
     }
     ```
     - Note:
     Since ItemViewModels can be used as ModelType objects, default implementation returns it as an ItemViewModelType object or nil otherwise
    */
    func itemViewModel(fromModel model: ModelType) -> ItemViewModelType?
    
    /**
     Fully reloads current contents by triggering inner ListDataHolder's reload method
    */
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
    }
}

public extension ListViewModelType where Self: ViewModelTypeFailable, Self: ViewModelTypeSelectable {
    var fail: Observable<ActionError> {
        return Observable.from([self.dataHolder.reloadAction.errors, self.selection.errors], scheduler: MainScheduler.instance).switchLatest()
    }
}
