//
//  ListDataHolder.swift
//  Boomerang
//
//  Created by Stefano Mondino on 06/08/18.
//

import Foundation
import RxSwift
import RxCocoa
import Action
/**
 A generic protocol used to identify ranges with indexPaths
 */
public protocol ResultRangeType {
    /**
     Range's starting index
     */
    var start: IndexPath {get set}
    /**
     Range's end index
     */
    var end: IndexPath {get set}
}

/**
 Concrete implementation of ResultRangeType
 */

public struct ResultRange: ResultRangeType {
    
    public var start: IndexPath
    public var end: IndexPath
    
    /**
     Creates a  new ResultRange object with provided start and end indexes
    */
    public init?(start: IndexPath?, end: IndexPath?) {
        guard let start = start, let end = end else { return nil }
        self.start = start
        self.end = end
    }
}

/**
 Defines how a generic list should be updated
 */
public enum ListDataUpdate {
    /// Fully reload the list
    case reload(ResultRangeType?)
    /// Insert the object at index's start. Current item at index will be placed after the new data
    case insert(ResultRangeType?)
    /// Delete items in range
    case delete(ResultRangeType?)
    /// Insert incoming data as new sections. Last index indexpath is ignored (ex: in two-dimensional ModelStructure, new content is inserted as a new child ModelStructure, before the one currently at indexPath.section's index.
    case insertSections(ResultRangeType?)
    /// Deletes full section in a multidimensional ModelStructure
    case deleteSections(ResultRangeType?)
}

/**
 Generic definition of a ListDataHolder.
 A ListDataHolder is used by ListViewModels to handle the retrieval of external data, store and update them, and lazily convert them into ItemViewModels.
 */
public protocol ListDataHolderType: class {
    /**
    A map used to hold references to ItemViewModels
    */
    var viewModels: BehaviorRelay<[IndexPath: ItemViewModelType]> {get set}
    
    /**
     An observable property with current results count.
     */
    var resultsCount: BehaviorRelay<Int> {get set}
    
    /**
     An observable property with current loading status.
    */
    var isLoading: BehaviorRelay<Bool> {get}
    
    /**
     Notify (manually if needed) if new data is available in the list.
     */
    var newDataAvailable: BehaviorRelay<ListDataUpdate?> {get set}
    
    /// Observable relay for for current ModelStructure.
    var modelStructure: BehaviorRelay<ModelStructure> {get set}
    
    /// Triggers a reload after inner data has changed
    var commitEditing: BehaviorRelay<Bool> { get }
    
    /// Inner Action used to trigger updates and emit new values when available
    var reloadAction: Action<ResultRangeType?, ModelStructure> {get set}
    
    /// Supplementary action useful for "infinite scrolling" scenarios, where new data has to be added to the list without a complete reload
    var moreAction: Action<ResultRangeType?, ModelStructure> {get set}
    
    /// Deletes item from inner model structure at provided index path
    func deleteItem(atIndex index: IndexPath)
    
    /// Moves an item between indexes
    func move(from: IndexPath, to: IndexPath) 
    
    /// Completely reloads current data by creating a new subscription to provided data observable
    func reload()
    
    /// Notify every subscriber that an update procedure over inner ModelStructure has completed. This is useful in scenarios where some items are deleted AND inserted at once: in that case, `commit()` must be called at the end to notify UI components to only update once
    func commit()
    
    /// Basic initializer. Returns an empty data holder
    init()
}

private struct AssociatedKeys {
    static var disposeBag = "disposeBag"
}
private struct Dummy: ModelType {}
extension ListDataHolderType {
    
    /**
     A lazily-created disposeBag where disposables can be easily stored.
     */
    public var disposeBag: DisposeBag {
        get {
            var disposeBag: DisposeBag
            
            if let lookup = objc_getAssociatedObject(self, &AssociatedKeys.disposeBag) as? DisposeBag {
                disposeBag = lookup
            } else {
                disposeBag = DisposeBag()
                objc_setAssociatedObject(self, &AssociatedKeys.disposeBag, disposeBag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            
            return disposeBag
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.disposeBag, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /**
     Returns an empty data holder with an empty model structure
     */
    public static var empty: ListDataHolderType { return Self.init(data: Observable.just(ModelStructure.empty)) }
    
    /**
     Reloads data by executing inner `reloadAction` with no ResultRange provided. Data is expected to be fully refreshed.
    */
    public func reload() {
        self.reloadAction.execute(nil)
        
    }
    
    /** Notify every subscriber that an update procedure over inner ModelStructure has completed.
 
        This is useful in scenarios where some items are deleted AND inserted at once: in that case, `commit()` must be called at the end to notify UI components to only update once.
        The `commitEditing` relay's value is set to `true`
     */
    
    public func commit() {
        self.commitEditing.accept(true)
        
    }
    /// Deletes item from current model structure at provided index path
    /// `newDataAvailable` is immediately set to `.delete` with proper index path
    public func deleteItem(atIndex index: IndexPath) {
        let model = self.modelStructure.value
        
        model.deleteItem(atIndex: index)
        var vms = self.viewModels.value
        vms[index] = nil
        self.viewModels.accept(vms)
        self.modelStructure.accept(model)
        self.newDataAvailable.accept(ListDataUpdate.delete(ResultRange(start: index, end: index)))
    }
    
    /**
        Insert a new ModelType at provided indexPath
     
        - Note:
        This causes a complete recalculation of contents of `viewModels`
        This will likely change in the future
    */
    

    public func insert(item: ModelType, atIndex index: IndexPath) {
        let model = self.modelStructure.value
        model.insert(item: item, atIndex: index)
        // This is a potentially dangerous operation.
        // It would be better to find a way to shift previous viewModels instead of destroying all of them (if not already retained somewhere else)
        var vms = self.viewModels.value
        vms = [:]
        self.viewModels.accept(vms)
        self.modelStructure.accept(model)
        self.newDataAvailable.accept(ListDataUpdate.insert(ResultRange(start: index, end: index)))
    }
    
    /**
     Insert an array of ModelType objects starting at provided indexPath
     
     - Note:
     This causes a complete recalculation of contents of `viewModels`
     This will likely change in the future
     */
    public func insert(items: [ModelType], startingFromIndex index: IndexPath) {
        let model = self.modelStructure.value
        let lastIndex = IndexPath(item: index.item + items.count - 1, section: index.section)
        items.reversed().forEach { model.insert(item: $0, atIndex: index)}
        var vms = self.viewModels.value
        vms = [:]
        self.viewModels.accept(vms)
        self.modelStructure.accept(model)
        self.newDataAvailable.accept(ListDataUpdate.insert(ResultRange(start: index, end: lastIndex)))
    }
    
    /**
     Insert a new ModelStructure as children of current ModelStructure at provided indexPath
     
     - Note:
     This causes a complete recalculation of contents of `viewModels`
     This will likely change in the future
     */
    public func insert(structure: ModelStructure, startingFromIndex index: IndexPath) {
        let oldModel = self.modelStructure.value
        //Probably a bug here, we should add:
        //structure.preferredIndexPath = index
        let model = oldModel.inserting(structure)
        model.children = model.children?.filter {($0.models?.count ?? 0) > 0}
        //        let lastIndex = IndexPath(item: index.item + items.count - 1 , section: index.section)
        //        items.reversed().forEach { model.insert(item: $0, atIndex: index)}
        var vms = self.viewModels.value
        vms = [:]
        self.viewModels.accept(vms)
        self.modelStructure.accept(model)
        if let lastIndex = structure.indexPaths().last {
            self.newDataAvailable.accept(ListDataUpdate.insert(ResultRange(start: index, end: lastIndex)))
        }
    }
    
    public func move(from: IndexPath, to: IndexPath) {
        let structure = self.modelStructure.value
        guard let item = structure.modelAtIndex(from) else { return }
        var vms = self.viewModels.value
        let fromVM = vms[from]
        let toVM = vms[to]
        
        
        structure.deleteItem(atIndex: from)
        
        structure.insert(item: item, atIndex: to)
        
        
        // This is a potentially dangerous operation.
        // It would be better to find a way to shift previous viewModels instead of destroying all of them (if not already retained somewhere else)
        vms[to] = fromVM
        vms[from] = toVM
        self.viewModels.accept(vms)
        self.modelStructure.accept(structure)
//        self.newDataAvailable.accept(ListDataUpdate.insert(ResultRange(start: index, end: index)))
    }
    
    /**
     Creates a new ListDataHolder
     - Parameters:
        - data: an observable that will emit the root ModelStructure after reload.
        - more: an optional observable that will be triggered whenever `moreAction` will be executed and will append its ModelStructure's contents to current ModelStructure.
     
     - Example:
     ```
     let dataHolder = ListDataHolder(data:.just(ModelStructure(["A","B","C"])), more:.just(ModelStructure(["D","E","F"]))
     dataHolder.reload()
     /// current contents: "A", "B", "C"
     dataHolder.moreAction.execute(nil)
     /// current contents: "A", "B", "C", "D", "E", "F"
     ```
     
     */
    public init(data: Observable<ModelStructure>, more: Observable<(ModelStructure)>? = nil) {
        self.init()
        self.reloadAction = Action { _ in
            return data.flatMapLatest { (s: ModelStructure?) -> Observable<ModelStructure> in
                let result = (s ?? ModelStructure.empty)
                return Observable.just(result)
            }
        }
        if let more = more {
            self.moreAction = Action(enabledIf: reloadAction.enabled.delay(0, scheduler: MainScheduler.instance)) {[weak self] range in
                if (self?.resultsCount.value ?? 0) < 1 { return .empty() }
                return more.map {
                    $0.preferredIndexPath = range?.start
                    return $0
                }
            }
        }
        let moreAction = self.moreAction
        
        reloadAction.elements.flatMapLatest {[weak self] reload -> Observable<ModelStructure> in
            self?.modelStructure.accept(reload)
            
            return moreAction.elements.map { $0 }.startWith(nil).map { [weak self] in
                if let ms = $0 {
                    return (self?.modelStructure.value ?? reload).inserting(ms)
                } else {
                    return self?.modelStructure.value ?? reload
                }
            }
            }
            .skip(1)
            .observeOn(MainScheduler.instance)
            .catchErrorJustReturn(ModelStructure.empty)
            .bind(to: modelStructure)
            .disposed(by: disposeBag)
        
        Observable.from([reloadAction.elements
            .map { $0.indexPaths()}.map { indexPaths -> ListDataUpdate? in
                let range: ResultRangeType? = ResultRange(start: indexPaths.first, end: indexPaths.last)
                return ListDataUpdate.reload(range)
            }, moreAction.elements
                .delay(0, scheduler: MainScheduler.instance)
                .map { [weak self ] structure -> [IndexPath] in
                    if let ip = structure.preferredIndexPath, let s = self?.modelStructure.value {
                        let finalIp: IndexPath
                        if let children = s.children {
                            finalIp =  IndexPath(item: max((children[ip.section].models?.count ?? 1)-1, ip.item), section: ip.section)
                        } else {
                            finalIp = IndexPath(item: max((s.models?.count ?? 1)-1, ip.item), section: 0)
                        }
                        let startIp = IndexPath(item: min(finalIp.item, ip.item), section: ip.section)
                        return [startIp, finalIp]
                    } else {
                        return Array(self?.modelStructure.value.indexPaths().suffix(structure.count) ?? [])
                    }
                }.map {
                    indexPaths in
                    let range: ResultRangeType? = ResultRange(start: indexPaths.first, end: indexPaths.last)
                    return ListDataUpdate.insert(range)
            }
            ]
            ).merge()
            //.asDriver(onErrorJustReturn:nil)
            .asObservable()
            .catchErrorJustReturn(nil)
            .observeOn(MainScheduler.instance)
            .bind(to: newDataAvailable)
            .disposed(by: disposeBag)
        
        self.reloadAction.elements
            .asObservable()
            .map {_ in return [IndexPath: ItemViewModelType]()}
            .asObservable()
            .catchErrorJustReturn([:])
            .observeOn(MainScheduler.instance)
            .bind(to: viewModels)
            .disposed(by: self.disposeBag)
        
        self.modelStructure
            .asObservable()
            .map { return $0.count}
            .catchErrorJustReturn(0)
            .observeOn(MainScheduler.instance)
            .bind(to: resultsCount)
            .disposed(by: self.disposeBag)
        
        reloadAction.executing
            .catchErrorJustReturn(false)
            .observeOn(MainScheduler.instance)
            .bind(to: isLoading)
            .disposed(by: self.disposeBag)
    }
}

/**
 Concrete implementation of ListDataHolderType
 */
public final class ListDataHolder: ListDataHolderType {
    /**
     An observable property with current loading status.
     */
    public let isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
     /// Inner Action used to trigger updates and emit new values when available
    public var reloadAction: Action<ResultRangeType?, ModelStructure> = Action {_ in return Observable.just(ModelStructure.empty)}
    
     /// Supplementary action useful for "infinite scrolling" scenarios, where new data has to be added to the list without a complete reload
    public var moreAction: Action<ResultRangeType?, ModelStructure> = Action { _ in return .just(.empty) }
    
    /// Observable relay for for current ModelStructure.
    public var modelStructure: BehaviorRelay<ModelStructure> = BehaviorRelay(value: ModelStructure.empty)
    
    /// A map used to hold references to ItemViewModels
    public var viewModels: BehaviorRelay = BehaviorRelay(value: [IndexPath: ItemViewModelType]())
    
    /// An observable property with current results count.
    public var resultsCount: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    /// Notify (manually if needed) if new data is available in the list.
    public var newDataAvailable: BehaviorRelay<ListDataUpdate?> = BehaviorRelay(value: nil)
    
     /// Triggers a reload after inner data has changed
    public var commitEditing: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    
    /// Initializes an empty ListDataHolder
    public init() {}
    
    /**
     Convenience method to create a ListDataHolder that instantly emits a single-dimension ModelStructure upon reloading
     - Parameters:
        - models: a ModelType array that will be used to create a single-dimension (no children) ModelStructure (``` ModelStructure(models)```)
     */
    public convenience init(withModels models: [ModelType]) {
        self.init(data: .just(ModelStructure(models)))
    }
}
