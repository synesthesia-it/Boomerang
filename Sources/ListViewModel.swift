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


public let defaultListIdentifier = "default_list_identifier"

extension String : ListIdentifier {
    public var name : String {
        return self
    }
    public var type: String? {
        return nil
    }
}
public protocol ListIdentifier {
    var name : String { get }
    var type : String? { get }
    var isEmbeddable : Bool { get }
}
extension ListIdentifier {
    public var isEmbeddable : Bool { return false }
}

public protocol ResultRangeType {
    var start:IndexPath {get set}
    var end:IndexPath {get set}
}

public struct ResultRange : ResultRangeType {
    public var start: IndexPath
    public var end:IndexPath
    public init?(start:IndexPath?, end:IndexPath?) {
        guard let start = start, let end = end else { return nil }
        self.start = start
        self.end = end
    }
}


extension IndexPath : SelectionInput {}

public enum ListDataUpdate {
    case reload(ResultRangeType?)
    case insert(ResultRangeType?)
    case delete(ResultRangeType?)
    case insertSections(ResultRangeType?)
    case deleteSections(ResultRangeType?)
}


public protocol ListDataHolderType : class {
    
    var viewModels:BehaviorRelay<[IndexPath:ItemViewModelType]> {get set}
    
    var resultsCount:BehaviorRelay<Int> {get set}
    var isLoading:BehaviorRelay<Bool> {get}
    
    var newDataAvailable:BehaviorRelay<ListDataUpdate?> {get set}
    
    var modelStructure : BehaviorRelay<ModelStructure> {get set}
    
    var commitEditing: BehaviorRelay<Bool> { get }
    
    var reloadAction:Action<ResultRangeType?,ModelStructure> {get set}
    var moreAction:Action<ResultRangeType?,ModelStructure> {get set}
    
    var data:Observable<ModelStructure> {get set}
    func deleteItem(atIndex index:IndexPath)
    func reload()
    func commit()
    init()
}



private struct AssociatedKeys {
    static var disposeBag = "disposeBag"
}
extension ListDataHolderType {
    
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
    public static var empty:ListDataHolderType { return Self.init(data: Observable.just(ModelStructure.empty)) }
    public func reload() {
        self.reloadAction.execute(nil)
        
    }
    public func commit() {
        self.commitEditing.accept(true)
        
    }
    public func deleteItem(atIndex index:IndexPath) {
        let model = self.modelStructure.value
        
        model.deleteItem(atIndex: index)
        var vms = self.viewModels.value
        vms[index] = nil
        self.viewModels.accept(vms)
        self.modelStructure.accept(model)
        self.newDataAvailable.accept(ListDataUpdate.delete(ResultRange(start: index, end: index)))
    }
    public func insert(item:ModelType , atIndex index:IndexPath) {
        let model = self.modelStructure.value
        model.insert(item: item, atIndex: index)
        
        var vms = self.viewModels.value
        vms = [:]
        self.viewModels.accept(vms)
        self.modelStructure.accept(model)
        self.newDataAvailable.accept(ListDataUpdate.insert(ResultRange(start: index, end: index)))
    }
    public func insert(items:[ModelType], startingFromIndex index:IndexPath) {
        let model = self.modelStructure.value
        let lastIndex = IndexPath(item: index.item + items.count - 1 , section: index.section)
        items.reversed().forEach { model.insert(item: $0, atIndex: index)}
        var vms = self.viewModels.value
        vms = [:]
        self.viewModels.accept(vms)
        self.modelStructure.accept(model)
        self.newDataAvailable.accept(ListDataUpdate.insert(ResultRange(start: index, end: lastIndex)))
    }
    public func insert(structure:ModelStructure, startingFromIndex index:IndexPath) {
        var oldModel = self.modelStructure.value
        var model = oldModel.inserting(structure)
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
    public init(data:Observable<ModelStructure>, more:Observable<(ModelStructure)>? = nil) {
        self.init()
        self.data = data
        self.reloadAction = Action { range in
            return data.flatMapLatest { (s:ModelStructure?) -> Observable<ModelStructure> in
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
            
            return moreAction.elements.map { $0 as? ModelStructure}.startWith(nil).map { [weak self] in
                if let ms = $0 {
                    return (self?.modelStructure.value ?? reload).inserting(ms)
                } else {
                    return self?.modelStructure.value ?? reload
                }
            }
            
            }
            //        Observable.combineLatest(reloadAction.elements,moreAction.elements.startWith(.empty)) { original, newItems -> ModelStructure in
            //                let result =  original + newItems
            //            return result
            //            }
            .skip(1)
            .asDriver(onErrorJustReturn: ModelStructure.empty).drive(modelStructure).disposed(by:self.disposeBag)
        
        
        Observable.from([reloadAction.elements
            .map  { $0.indexPaths()}.map { indexPaths -> ListDataUpdate? in
                let range:ResultRangeType? = ResultRange(start:indexPaths.first,end:indexPaths.last)
                return ListDataUpdate.reload(range)
            }
            , moreAction.elements
                .delay(0,scheduler: MainScheduler.instance)
                .map { [weak self ] structure -> [IndexPath] in
                    if let ip = structure.preferredIndexPath, let s = self?.modelStructure.value {
                        let finalIp:IndexPath
                        if let children = s.children {
                            finalIp =  IndexPath(item:max((children[ip.section].models?.count ?? 1)-1,ip.item), section:ip.section)
                        } else {
                            finalIp = IndexPath(item: max((s.models?.count ?? 1)-1,ip.item), section: 0)
                        }
                        let startIp = IndexPath(item: min(finalIp.item, ip.item), section:ip.section)
                        return [startIp,finalIp]
                    } else {
                        return Array(self?.modelStructure.value.indexPaths().suffix(structure.count) ?? [])
                    }
                }.map {
                    indexPaths in
                    let range:ResultRangeType? = ResultRange(start:indexPaths.first,end:indexPaths.last)
                    return ListDataUpdate.insert(range)
            }
            ]
            ).merge()
            .asDriver(onErrorJustReturn:nil)
            
            .drive(newDataAvailable).disposed(by: disposeBag)
        
        
        self.reloadAction.elements.asObservable().map{_ in return [IndexPath:ItemViewModelType]()}.asDriver(onErrorJustReturn: [:]).drive(viewModels).disposed(by:self.disposeBag)
        self.modelStructure.asObservable().map { return $0.count}.asDriver(onErrorJustReturn: 0).drive(resultsCount).disposed(by:self.disposeBag)
        reloadAction.executing.asDriver(onErrorJustReturn: false).drive(self.isLoading).disposed(by:self.disposeBag)
    }
}
public final class ListDataHolder : ListDataHolderType {
    
    public let isLoading: BehaviorRelay<Bool> = BehaviorRelay(value:false)
    public var reloadAction: Action<ResultRangeType?, ModelStructure> = Action {_ in return Observable.just(ModelStructure.empty)}
    public var moreAction:Action<ResultRangeType?, ModelStructure> = Action { _ in return .just(.empty) }
    public var modelStructure:BehaviorRelay<ModelStructure> = BehaviorRelay(value:ModelStructure.empty)
    public var viewModels:BehaviorRelay = BehaviorRelay(value:[IndexPath:ItemViewModelType]())
    public var resultsCount:BehaviorRelay<Int> = BehaviorRelay(value:0)
    public var newDataAvailable:BehaviorRelay<ListDataUpdate?> = BehaviorRelay(value:nil)
    public var data:Observable<ModelStructure>
    public var commitEditing: BehaviorRelay<Bool> = BehaviorRelay(value:true)
    public init() {
        self.data = .just(ModelStructure.empty)
    }
    public convenience init(withModels models:[ModelType]) {
        self.init(data:.just(ModelStructure(models)))
    }
}
public protocol ListViewModelType : ViewModelType {
    var dataHolder:ListDataHolderType {get set}
    func identifier(atIndex index:IndexPath) -> ListIdentifier?
    func model (atIndex index:IndexPath) -> ModelType?
    func itemViewModel(fromModel model:ModelType) -> ItemViewModelType?
    var listIdentifiers:[ListIdentifier] {get}
    func reload()
    
}


public protocol ListViewModelTypeSectionable : ListViewModelType {
    var sectionIdentifiers: [ListIdentifier]{get}
    func sectionItemViewModel(fromModel model:ModelType, withType type:String) -> ItemViewModelType?
}

public extension ListViewModelTypeSectionable {
    
    public func sectionItemViewModel(fromModel model:ModelType, withType type:String) -> ItemViewModelType? {
        return self.itemViewModel(fromModel: model)
    }
}
public extension ListViewModelType  {
    
    public var isEmpty:Observable<Bool> {
        return self.dataHolder.resultsCount.asObservable().map {$0 == 0}
    }
    
    public func identifier(atIndex index:IndexPath) -> ListIdentifier? {
        return self.viewModel(atIndex:index)?.itemIdentifier
    }
    public func viewModel (atIndex index:IndexPath) -> ItemViewModelType? {
        
        var d = self.dataHolder.viewModels.value
        let vm = d[index]
        if (vm == nil) {
            guard let model:ModelType =  self.dataHolder.modelStructure.value.modelAtIndex(index) else {
                return nil
            }
            let item =  self.itemViewModel(fromModel: model)
            d[index] = item
            self.dataHolder.viewModels.accept(d)
            return item
        }
        return vm
    }
    
    public func itemViewModel(fromModel model:ModelType) -> ItemViewModelType? {
        return model as? ItemViewModelType
    }
    
}

public extension ListViewModelType {
    //    public func model<Model:ModelType> (atIndex index:IndexPath) -> Model? {
    //        let model = self.dataHolder.modelStructure.value.modelAtIndex(index) as? Model
    //        guard let viewModel = model as? ItemViewModelType else {
    //            return model
    //        }
    //        return viewModel.model as? Model
    //    }
    public func model (atIndex index:IndexPath) -> ModelType? {
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

public extension ListViewModelType where Self :  ViewModelTypeFailable {
    var fail:Observable<ActionError> { return self.dataHolder.reloadAction.errors }
}
public extension ListViewModelType where Self :  ViewModelTypeLoadable {
    var loading:Observable<Bool> { return self.dataHolder.reloadAction.executing }
}
public extension ListViewModelType where Self :  ViewModelTypeLoadable , Self: ViewModelTypeSelectable {
    var loading:Observable<Bool> {
        return Observable.combineLatest(self.dataHolder.reloadAction.executing, self.selection.executing, resultSelector: { $0 || $1})
        
        //        return self.dataHolder.reloadAction.isExecuting.signal.combineLatest(with: (self.selection.isExecuting.signal ?? Signal<Bool,NoError>.empty) ).map {return $0 || $1}
        
        
    }
}
public extension ListViewModelType where Self :  ViewModelTypeFailable , Self: ViewModelTypeSelectable {
    var fail:Observable<ActionError> {
        return Observable.from([self.dataHolder.reloadAction.errors, self.selection.errors], scheduler: MainScheduler.instance).switchLatest()
    }
}

