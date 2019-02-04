//
//  DataHolder.swift
//  Boomerang
//
//  Created by Stefano Mondino on 19/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import Action

public typealias DataUpdate = () -> ([IndexPath])
typealias ViewModelCache = GroupCache<IdentifiableViewModelType>

public enum DataHolderUpdate {
    case reload
    case deleteItems(DataUpdate)
    case insertItems(DataUpdate)
    case move(DataUpdate)
    case none
}

public class DataHolder {
    public var groups: Observable<DataGroup> {
        return self._modelGroup.asObservable().do(onNext: {[weak self] _ in
            self?.itemCache.clear()
        })
    }
    public var isLoading: Observable<Bool> {
        return action.executing
    }
    public var errors: Observable<Error> {
        return  action.errors.map {
            switch $0 {
            case.underlyingError(let e): return e
            default: return nil
            }
            }
            .flatMap { Observable.from(optional: $0)}
        
    }
    
    public fileprivate(set) var modelGroup: DataGroup {
        get { return (try? _modelGroup.value()) ?? .empty }
        set { _modelGroup.onNext(newValue)}
    }
    
    internal var itemCache: ViewModelCache = ViewModelCache()
    
    public var useCache: Bool {
        get {
            return self.itemCache.isEnabled
        }
        set {
            self.itemCache.isEnabled = newValue
        }
    }
    
    internal let updates: BehaviorSubject<DataHolderUpdate> = BehaviorSubject(value: .none)
    
    private let disposeBag = DisposeBag()
    private let action: Action<Void, DataGroup>
    private let _modelGroup: BehaviorSubject<DataGroup> = BehaviorSubject(value: DataGroup.empty)
    private let interrupt: BehaviorSubject<()>
    
    public init() {
        action = Action { .empty() }
        interrupt = BehaviorSubject(value: ())
    }
    public init(data: Observable<DataGroup>, cancelWith interrupt: BehaviorSubject<()> = BehaviorSubject(value: ()) ) {
        self.interrupt = interrupt
        self.action = Action { _ in
            return data.takeUntil(interrupt.skip(1))
        }
       
        self.action
            .elements
            .bind(to: _modelGroup)
            .disposed(by: disposeBag)
        
        self.action.elements
            .map {_ in DataHolderUpdate.reload }
            .bind(to: updates)
            .disposed(by: disposeBag)
    }
    
    public func cancel() {
        self.interrupt.onNext(())
    }
    
    public func start() {
        self.action.execute(())
    }
}

extension DataHolder: MutableCollection, RandomAccessCollection {
    public subscript(position: Index) -> Element {
        get {
            return modelGroup[position]
        }
        set(newValue) {
            var group = modelGroup
            group[position] = newValue
            _modelGroup.onNext(group)
        }
    }
    
    public typealias Element = DataGroup.Element
    public typealias Index = DataGroup.Index
    public typealias SubSequence = DataGroup.SubSequence
    
    public var startIndex: DataGroup.Index {
        return self.modelGroup.startIndex
    }
    
    public var endIndex: DataGroup.Index {
        return self.modelGroup.endIndex
    }
    
    public func index(after i: DataHolder.Index) -> DataHolder.Index {
        return modelGroup.index(after: i)
    }
    public func index(before i: DataHolder.Index) -> DataHolder.Index {
        return modelGroup.index(before: i)
    }
}

extension DataHolder {
    
    public func insert(_ data: [DataType], at indexPath: IndexPath, immediate: Bool = false) {
        let insertion: DataUpdate = {[weak self] in
            guard let self = self else { return [] }
            guard let newIndexPath = self.modelGroup.insert(data, at: indexPath.suffix(self.modelGroup.depth)) else {
                return []
            }
            let lastIndex: Int = data.count + (newIndexPath.last ?? 0)
            let firstIndex = newIndexPath.last ?? 0
            
            return (firstIndex..<lastIndex).map {
                let indexPath = indexPath.dropLast().appending($0)
                self.itemCache.replaceItem(nil, at: indexPath)
                return indexPath
            }
        }
        if immediate {
            _ = insertion()
        } else {
            self.updates.onNext(.insertItems(insertion))
        }
    }
    public func delete(at indexPaths:[IndexPath], immediate: Bool = false) {
        let delete: DataUpdate = {[weak self] in
            guard let self = self else { return [] }
            let deletedIndexPaths = self.modelGroup.delete(at: indexPaths).compactMap {
                $0.value != nil ? $0.key : nil
            }
            deletedIndexPaths.forEach {
                self.itemCache.replaceItem(nil, at: $0)
                self.itemCache.replaceSupplementaryItem(nil, at: $0, for: nil)
            }
            return deletedIndexPaths
        }
        if immediate {
            _ = delete()
        } else {
            self.updates.onNext(.deleteItems(delete))
        }
    }
    public func moveItem(from: IndexPath, to:IndexPath, immediate: Bool = false) {
        let move: DataUpdate = {[weak self] in
            guard let self = self else { return [] }
            self.modelGroup.move(from: from, to: to)
           
            let tmp = self.itemCache.mainItem(at: from)
            self.itemCache.replaceItem(self.itemCache.mainItem(at: to), at: from)
            self.itemCache.replaceItem(tmp, at: to)
            
            return []
        }
        if immediate {
            _ = move()
        } else {
            self.updates.onNext(.move(move))
        }
    }
}

extension DataHolder {
    func supplementaryItem(at indexPath: IndexPath, for type: String) -> DataType? {
        return modelGroup.supplementaryData(at: indexPath, for: type)
    }
}
