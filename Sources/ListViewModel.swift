//
//  ViewModelList.swift
//  Boomerang
//
//  Created by Stefano Mondino on 10/11/16.
//
//

import Foundation
import ReactiveSwift

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


public protocol SelectionType {}

extension IndexPath : SelectionType {}
public protocol ListDataHolderType : class {
    var viewModels:MutableProperty<[IndexPath:ItemViewModelType]> {get set}
    var isLoading:MutableProperty<Bool> {get set}
    var resultsCount:MutableProperty<Int> {get set}
    var newDataAvailable:MutableProperty<ResultRangeType?> {get set}
    var models:MutableProperty<ModelStructure> {get set}
    var reloadAction:Action<ResultRangeType?,ModelStructure,NSError> {get set}
    var dataProducer:SignalProducer<ModelStructure?,NSError> {get set}
    func reload()
    init()
}
extension ListDataHolderType {
    public static var empty:ListDataHolderType { return Self.init(dataProducer: SignalProducer(value:ModelStructure.empty)) }
    public func reload() {
        self.reloadAction.apply(nil).start()
    }
    public init(dataProducer:SignalProducer<ModelStructure?,NSError>) {
        self.init()
        self.dataProducer = dataProducer
        self.reloadAction = Action { range in
            return dataProducer.flatMap(.latest) { (s:ModelStructure?) -> SignalProducer<ModelStructure,NSError> in
                let result = (s ?? ModelStructure.empty)
                return SignalProducer(value:result)
            }
        }
        self.models <~ reloadAction.values
        self.viewModels <~ self.models.producer.map{_ in return [IndexPath:ItemViewModelType]()}
        self.isLoading <~ reloadAction.isExecuting
        self.resultsCount <~ self.models.producer.map { return $0.count}
        
    }
}
public final class ListDataHolder : ListDataHolderType {
    

    public var reloadAction: Action<ResultRangeType?, ModelStructure, NSError> = Action {_ in return SignalProducer(value:ModelStructure.empty)}
    public var models:MutableProperty<ModelStructure> = MutableProperty(ModelStructure.empty)
    public var viewModels:MutableProperty = MutableProperty([IndexPath:ItemViewModelType]())
    public var isLoading:MutableProperty<Bool> = MutableProperty(false)
    public var resultsCount:MutableProperty<Int> = MutableProperty(0)
    public var newDataAvailable:MutableProperty<ResultRangeType?> = MutableProperty(nil)
    public var dataProducer:SignalProducer<ModelStructure?,NSError>
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
    func select(selection:SelectionType) -> ViewModelType
    func reload()
    init()
}


public protocol ListViewModelTypeHeaderable : ListViewModelType {
    func headerIdentifiers() -> [ListIdentifier]
}
public extension ListViewModelType {

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
    init(dataProducer:SignalProducer<ModelStructure?,NSError>) {
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
