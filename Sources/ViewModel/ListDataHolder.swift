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

public protocol ResultRangeType {
    var start: IndexPath {get set}
    var end: IndexPath {get set}
}

public struct ResultRange: ResultRangeType {
    public var start: IndexPath
    public var end: IndexPath
    public init?(start: IndexPath?, end: IndexPath?) {
        guard let start = start, let end = end else { return nil }
        self.start = start
        self.end = end
    }
}

extension IndexPath: SelectionInput {}

public enum ListDataUpdate {
    case reload(ResultRangeType?)
    case insert(ResultRangeType?)
    case delete(ResultRangeType?)
    case insertSections(ResultRangeType?)
    case deleteSections(ResultRangeType?)
}

public protocol ListDataHolderType: class {
    
    var viewModels: BehaviorRelay<[IndexPath: ItemViewModelType]> {get set}
    
    var resultsCount: BehaviorRelay<Int> {get set}
    var isLoading: BehaviorRelay<Bool> {get}
    
    var newDataAvailable: BehaviorRelay<ListDataUpdate?> {get set}
    
    var modelStructure: BehaviorRelay<ModelStructure> {get set}
    
    var commitEditing: BehaviorRelay<Bool> { get }
    
    var reloadAction: Action<ResultRangeType?, ModelStructure> {get set}
    var moreAction: Action<ResultRangeType?, ModelStructure> {get set}
    
    var data: Observable<ModelStructure> {get set}
    func deleteItem(atIndex index: IndexPath)
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
    public static var empty: ListDataHolderType { return Self.init(data: Observable.just(ModelStructure.empty)) }
    public func reload() {
        self.reloadAction.execute(nil)
        
    }
    public func commit() {
        self.commitEditing.accept(true)
        
    }
    public func deleteItem(atIndex index: IndexPath) {
        let model = self.modelStructure.value
        
        model.deleteItem(atIndex: index)
        var vms = self.viewModels.value
        vms[index] = nil
        self.viewModels.accept(vms)
        self.modelStructure.accept(model)
        self.newDataAvailable.accept(ListDataUpdate.delete(ResultRange(start: index, end: index)))
    }
    public func insert(item: ModelType, atIndex index: IndexPath) {
        let model = self.modelStructure.value
        model.insert(item: item, atIndex: index)
        
        var vms = self.viewModels.value
        vms = [:]
        self.viewModels.accept(vms)
        self.modelStructure.accept(model)
        self.newDataAvailable.accept(ListDataUpdate.insert(ResultRange(start: index, end: index)))
    }
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
    public func insert(structure: ModelStructure, startingFromIndex index: IndexPath) {
        let oldModel = self.modelStructure.value
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
    public init(data: Observable<ModelStructure>, more: Observable<(ModelStructure)>? = nil) {
        self.init()
        self.data = data
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
public final class ListDataHolder: ListDataHolderType {
    
    public let isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    public var reloadAction: Action<ResultRangeType?, ModelStructure> = Action {_ in return Observable.just(ModelStructure.empty)}
    public var moreAction: Action<ResultRangeType?, ModelStructure> = Action { _ in return .just(.empty) }
    public var modelStructure: BehaviorRelay<ModelStructure> = BehaviorRelay(value: ModelStructure.empty)
    public var viewModels: BehaviorRelay = BehaviorRelay(value: [IndexPath: ItemViewModelType]())
    public var resultsCount: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public var newDataAvailable: BehaviorRelay<ListDataUpdate?> = BehaviorRelay(value: nil)
    public var data: Observable<ModelStructure>
    public var commitEditing: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    public init() {
        self.data = .just(ModelStructure.empty)
    }
    public convenience init(withModels models: [ModelType]) {
        self.init(data: .just(ModelStructure(models)))
    }
}
