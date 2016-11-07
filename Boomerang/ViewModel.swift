//
//  ViewModel.swift
//  Boomerang
//
//  Created by Stefano Mondino on 13/10/16.
//
//

import Foundation
import ReactiveSwift
import Result

//public typealias ListIdentifier = String


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

public class ModelStructure {
    var models:[ModelType]?
    var children:[ModelStructure]?
    var sectionModel:ModelType?
    
    
    
    public init (_ models:[ModelType], sectionModel:ModelType? = nil) {
        self.models = models
        self.sectionModel = sectionModel
    }
    public init (children:[ModelStructure]? ) {
        self.children = children
        
    }
    
    public static var empty:ModelStructure = ModelStructure([])
    var count : Int {
        return 0
    }
    func modelAtIndex(_ index: IndexPath) -> ModelType? {
        if (index.count == 1) {
        return self.models?[index.first!]
        }
        if (self.children == nil) {
            return self.models?[index.last ?? 0]
        }
        return self.children?[(index.first ?? 0)].modelAtIndex(index.dropFirst())
    }
    
}



public protocol ViewModelFactoryType {
    
}

public protocol SelectionType {
    
}


public protocol ViewModelType : class {
   
}

public protocol ResultRangeType {
    var start:IndexPath {get set}
    var end:IndexPath {get set}
}
public protocol ModelType {
    var title:String? {get}
}

extension IndexPath : SelectionType {
    
}

public protocol ViewModelListType : ViewModelType {
    init()
    func identifierAtIndex(_ index:IndexPath) -> ListIdentifier?
    func modelAtIndex (_ index:IndexPath) -> ModelType?
    var models:MutableProperty<ModelStructure> {get set}
    var viewModels:MutableProperty<[IndexPath:ViewModelItemType]> {get set}
    var isLoading:MutableProperty<Bool> {get set}
    var resultsCount:MutableProperty<Int> {get set}
    var newDataAvailable:MutableProperty<ResultRangeType?> {get set}
    func itemViewModel(_ model:ModelType) -> ViewModelItemType?
    func listIdentifiers() -> [ListIdentifier]
    func select(selection:SelectionType) -> ViewModelType
}

public protocol ViewModelItemType : ViewModelType {
    typealias T = ModelType
    var itemIdentifier:ListIdentifier {get set}
    var model:T {get set}
    init(model:T)
}

public extension ViewModelListType {
    
    public func identifierAtIndex(_ index:IndexPath) -> ListIdentifier? {
        return self.viewModelAtIndex(index)?.itemIdentifier
    }
    
//    open func modelAtIndex (_ index:Index) -> Any {
//        switch index {
//        case is NSIndexPath:
//            return self.listIdentifierAtIndexPath(index as! NSIndexPath)
//        case is Integer:
//            return self.list
//        default :return nil
//        }
//    }
    
    public func modelAtIndex (_ index:IndexPath) -> ModelType? {
        return self.models.value.modelAtIndex(index)
//        guard let matrix = self.models.value as? [[ModelType]] else {
//            return self.models.value[index.item] as? ModelType
//        }
//        return matrix[index.section][index.item]
    }
    public func viewModelAtIndex (_ index:IndexPath) -> ViewModelItemType? {
        
        var d = self.viewModels.value
        let vm = d[index]
        if (vm == nil) {
            let item =  self.itemViewModel(self.modelAtIndex(index)!)
            d[index] = item
            self.viewModels.value = d
            return item
        }
        return vm
        //return self.itemViewModel(self.modelAtIndex(index)!)
    }
    public func itemViewModel(_ model:ModelType) -> ViewModelItemType? {
        if (model is ViewModelItemType) {
            return model as? ViewModelItemType
        }
        return nil
    }
    
    public init(dataProducer:SignalProducer<ModelStructure?,NSError>) {
        self.init()
        let reloadAction = Action<Any,ModelStructure,NSError> { _ in
            return dataProducer.map{$0}.map {
                return $0 ?? ModelStructure.empty
            }
        }
//        let vm = self
        self.models <~ reloadAction.values
        self.viewModels <~ self.models.producer.map{_ in return [IndexPath:ViewModelItemType]()}
//            guard let array = $0 as? [[ModelType]] else {
//                guard let  array = $0 as? [ModelType] else {
//                    return []
//                }
//                return array.lazy.map { vm.itemViewModel(model:$0)!}
//            }
//            return array.lazy.map {$0.lazy.map {vm.itemViewModel(model:$0 )!}}
//        
//        }
        self.isLoading <~ reloadAction.isExecuting
        self.resultsCount <~ self.models.producer.map { return $0.count}
        
        reloadAction.apply("").start()
    }
    

}


public protocol ViewModelBindable {
    
    var disposable:CompositeDisposable? {get set}
    func bindViewModel(_ viewModel: ViewModelType?)
}

extension ViewModelBindable {
    public var disposable:CompositeDisposable? {
        get {return nil}
        set {}
    }
}
