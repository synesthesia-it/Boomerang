//
//  ViewModelList.swift
//  Boomerang
//
//  Created by Stefano Mondino on 10/11/16.
//
//

import Foundation
import ReactiveSwift
import Result

let defaultListIdentifier = "default_list_identifier"

extension String : ListIdentifier {
    public var name : String {
        return self
    }
    public var type: String? {
        return nil
    }
}
public protocol ListIdentifier {
    var name : String {get }
    var type : String? {get }
}


public protocol ResultRangeType {
    var start:IndexPath {get set}
    var end:IndexPath {get set}
}




extension IndexPath : SelectionInput {}
public protocol ListDataHolderType : class {
    var viewModels:MutableProperty<[IndexPath:ItemViewModelType]> {get set}

    var resultsCount:MutableProperty<Int> {get set}
    var newDataAvailable:MutableProperty<ResultRangeType?> {get set}
    var models:MutableProperty<ModelStructure> {get set}
    var reloadAction:Action<ResultRangeType?,ModelStructure,Error> {get set}
    var dataProducer:SignalProducer<ModelStructure,Error> {get set}
    func reload()
    init()
}
extension ListDataHolderType {
    public static var empty:ListDataHolderType { return Self.init(dataProducer: SignalProducer(value:ModelStructure.empty)) }
    public func reload() {
        self.reloadAction.apply(nil).start()
    }
    public init(dataProducer:SignalProducer<ModelStructure,Error>) {
        self.init()
        self.dataProducer = dataProducer
        self.reloadAction = Action { range in
            return dataProducer.flatMap(.latest) { (s:ModelStructure?) -> SignalProducer<ModelStructure,Error> in
                let result = (s ?? ModelStructure.empty)
                return SignalProducer(value:result)
            }
        }
        self.models <~ reloadAction.values
        self.viewModels <~ self.models.producer.map{_ in return [IndexPath:ItemViewModelType]()}
        self.resultsCount <~ self.models.producer.map { return $0.count}
        
    }
}
public final class ListDataHolder : ListDataHolderType {
    
    
    public var reloadAction: Action<ResultRangeType?, ModelStructure, Error> = Action {_ in return SignalProducer(value:ModelStructure.empty)}
    public var models:MutableProperty<ModelStructure> = MutableProperty(ModelStructure.empty)
    public var viewModels:MutableProperty = MutableProperty([IndexPath:ItemViewModelType]())
    public var resultsCount:MutableProperty<Int> = MutableProperty(0)
    public var newDataAvailable:MutableProperty<ResultRangeType?> = MutableProperty(nil)
    public var dataProducer:SignalProducer<ModelStructure,Error>
    public init() {
        self.dataProducer = SignalProducer(value:ModelStructure.empty)
    }
    
}
public protocol ListViewModelType : ViewModelType {
    var dataHolder:ListDataHolderType {get set}
    func identifierAtIndex(_ index:IndexPath) -> ListIdentifier?
    func modelAtIndex (_ index:IndexPath) -> ModelType?
    func itemViewModel(_ model:ModelType) -> ItemViewModelType?
    func listIdentifiers() -> [ListIdentifier]
    
    func reload()
    init()
}


public protocol ListViewModelTypeHeaderable : ListViewModelType {
    func headerIdentifiers() -> [ListIdentifier]
}
public extension ListViewModelType  {
    
    var isEmpty:SignalProducer<Bool,NoError> {
        return self.dataHolder.resultsCount.producer.map {$0 == 0}
    }
    
    public func identifierAtIndex(_ index:IndexPath) -> ListIdentifier? {
        return self.viewModelAtIndex(index)?.itemIdentifier
    }
    public func viewModelAtIndex (_ index:IndexPath) -> ItemViewModelType? {
        
        var d = self.dataHolder.viewModels.value
        let vm = d[index]
        if (vm == nil) {
            let item =  self.itemViewModel(self.modelAtIndex(index)!)
            d[index] = item
            self.dataHolder.viewModels.value = d
            return item
        }
        return vm
    }
    public func itemViewModel(_ model:ModelType) -> ItemViewModelType? {
        if (model is ItemViewModelType) {
            return model as? ItemViewModelType
        }
        return nil
    }
    init(dataProducer:SignalProducer<ModelStructure,Error>) {
        self.init()
        self.dataHolder = ListDataHolder(dataProducer: dataProducer)
    }
    
    //    init() {
    //        self.dataHolder = ListDataHolder(dataProducer:SignalProducer(value:ModelStructure.empty))
    //    }
}

public extension ListViewModelType {
    public func modelAtIndex (_ index:IndexPath) -> ModelType? {
        return self.dataHolder.models.value.modelAtIndex(index)
        
    }
    public func reload() {
        self.dataHolder.reload()
    }
}

public extension ListViewModelType where Self :  ViewModelTypeFailable {
    var fail:Signal<Error, NoError> { return self.dataHolder.reloadAction.errors }
}
public extension ListViewModelType where Self :  ViewModelTypeLoadable {
    var loading:Signal<Bool, NoError> { return self.dataHolder.reloadAction.isExecuting.signal }
}
public extension ListViewModelType where Self :  ViewModelTypeLoadable , Self: ViewModelTypeSelectable {
    var loading:Signal<Bool, NoError> { return self.dataHolder.reloadAction.isExecuting.signal.combineLatest(with: (self.selection.isExecuting.signal ?? Signal<Bool,NoError>.empty) ).map {return $0 || $1} }
}
public extension ListViewModelType where Self :  ViewModelTypeFailable , Self: ViewModelTypeSelectable {
    var fail:Signal<Error, NoError> {
        return Signal<Error,NoError>.merge([self.dataHolder.reloadAction.errors,(self.selection.errors ?? Signal<Error,NoError>.empty)])
    }
}

