//
//  FormViewModel.swift
//  Boomerang
//
//  Created by Stefano Mondino on 21/11/16.
//
//

import Foundation
import ReactiveSwift
import Result

public protocol FormValue   {
    static var empty: Self {get}
}
public protocol FormValueEquatable : FormValue, Equatable {
    
}

public protocol FormDataReference {
    var key:String {get}
}
extension String : FormDataReference {
    public var key:String {
        return self
    }
}
public protocol FormDataType: ModelType {
     var reference : FormDataReference {get set}
    func getValue() -> Any
}

public protocol FormDataMutableType : FormDataType {
    
    associatedtype Value : FormValue
   
    var value:MutableProperty<Value> {get}
}



public class FormData<Value : FormValueEquatable> : FormDataMutableType {
    public var reference : FormDataReference
    public var title: String? {
        return self.reference.key
    }
    public var value:MutableProperty<Value> = MutableProperty<Value>(Value.empty)
    public init(reference:FormDataReference, initialValue:Value = Value.empty) {
        self.reference = reference
        self.value.value = initialValue
    }
    public func getValue() -> Any {
        return self.value.value
    }
}

public protocol TextInput {
    var title:String? {get}
   var string:MutableProperty<String> {get set}
}

public protocol FormItemViewModel : ItemViewModelType, ModelType , TextInput{
    associatedtype DataValue : FormValueEquatable
    
    
    func toString(_ value:DataValue) -> String
    func toValue(_ value:String) -> DataValue
    init(data:FormData<DataValue>)
}
extension FormItemViewModel {
    public var title: String? {
        return nil
    }
    func setup(data:FormData<DataValue>) {
        self.string <~ data.value.map {[weak self] in self?.toString($0) ?? ""}.skipRepeats()
        data.value <~ self.string.map {[weak self] in return (self?.toValue($0) ?? DataValue.empty)}.skipRepeats().producer.delay(0.0, on: QueueScheduler.main)
        
    }
    public init(data:FormData<DataValue>) {
        self.init(model:data)
        self.setup(data: data)
    }
    
    
}

public protocol FormViewModelType : ListViewModelType {
    //func formData() -> [String : Any]
}

extension FormViewModelType {
    public func formData() -> [String : Any] {
//        return self.dataHolder.models.value.
        return self.dataHolder.models.value.allData()
            .map { item -> FormDataType? in
                guard let vm = item as? ItemViewModelType else {
                    return item as? FormDataType
                }
                return vm.model as? FormDataType
            }
            .filter {$0 != nil}
            .reduce([:], { (accumulator, data) -> [String : Any] in
                var a =  accumulator
                let key = data!.reference.key
                a[key] = data!.getValue()
                return a
        })
    }
}


extension String :FormValueEquatable {
    public static var empty: String = ""
}
open class StringFormItemViewModel : FormItemViewModel {
    public typealias DataValue = String
    public static var defaultItemIdentifier: ListIdentifier = defaultListIdentifier
    public var string:MutableProperty<String> = MutableProperty("")
    public var itemIdentifier: ListIdentifier = StringFormItemViewModel.defaultItemIdentifier
    public var model:ItemViewModelType.Model = FormData<DataValue>(reference: "")
    public var value:MutableProperty<DataValue> = MutableProperty(DataValue.empty)
    public var title: String?
    public required init () {}
    public required convenience init (data:FormData<DataValue>, title:String? = nil, itemIdentifier:ListIdentifier = StringFormItemViewModel.defaultItemIdentifier) {
        self.init(model:data as ItemViewModelType.Model)
        self.title = title
        self.setup(data: data)
        self.itemIdentifier = itemIdentifier
    }
    public func toString(_ value: DataValue) -> String {
        return value
    }
    public func toValue(_ value: String) -> DataValue {
        return value
    }
}

extension Bool :FormValueEquatable {
    public static var empty: Bool = false
}
open class BoolFormItemViewModel : FormItemViewModel {
    public typealias DataValue = Bool
    public static var defaultItemIdentifier: ListIdentifier = defaultListIdentifier
    public var string:MutableProperty<String> = MutableProperty("")
    public var itemIdentifier: ListIdentifier = BoolFormItemViewModel.defaultItemIdentifier
    public var model:ItemViewModelType.Model = FormData<DataValue>(reference: "")
    public var value:MutableProperty<DataValue> = MutableProperty(DataValue.empty)
    public var title: String?
    public required init () {}
    public required convenience init (data:FormData<DataValue>, title:String? = nil, itemIdentifier:ListIdentifier = BoolFormItemViewModel.defaultItemIdentifier) {
        self.init(model:data as ItemViewModelType.Model)
        self.title = title
        self.setup(data: data)
        self.itemIdentifier = itemIdentifier
    }
    public func toString(_ value: DataValue) -> String {
        return value ? "1" : "0"
    }
    public func toValue(_ value: String) -> DataValue {
        return value == "1" ? true : false
    }
}


extension Int :FormValueEquatable {
    public static var empty: Int = 0
}
open class IntFormItemViewModel : FormItemViewModel {
    public typealias DataValue = Int
    public static var defaultItemIdentifier: ListIdentifier = defaultListIdentifier
    public var string:MutableProperty<String> = MutableProperty("")
    public var itemIdentifier: ListIdentifier = IntFormItemViewModel.defaultItemIdentifier
    public var model:ItemViewModelType.Model = FormData<DataValue>(reference: "")
    public var value:MutableProperty<DataValue> = MutableProperty(DataValue.empty)
    public var title: String?
    public required init () {}
    public required convenience init (data:FormData<DataValue>, title:String? = nil , itemIdentifier:ListIdentifier = IntFormItemViewModel.defaultItemIdentifier) {
        self.init(model:data as ItemViewModelType.Model)
        self.title = title
        self.setup(data: data)
        self.itemIdentifier = itemIdentifier
    }
    public func toString(_ value: DataValue) -> String {
        return String(value)
    }
    public func toValue(_ value: String) -> DataValue {
        return Int(value) ?? DataValue.empty
    }
}

public protocol FormModel : FormValueEquatable, ModelType, SelectionInput, SelectionOutput {
    
}

open class MultiselectionItemViewModel<DataValue:FormModel> : FormItemViewModel, ListViewModelType, ViewModelTypeSelectable, ViewModelTypeActionSelectable {
    public var string: MutableProperty<String> = MutableProperty("")
    public var title:String?
//    public typealias DataValue = FormValue
    public var itemIdentifier: ListIdentifier  = defaultListIdentifier
    public var dataHolder: ListDataHolderType = ListDataHolder.empty
    public var model:ItemViewModelType.Model = FormData<DataValue>(reference: "")
    public var itemViewModelClosure: (ModelType) -> (ItemViewModelType?)  = {_ in return nil}
    private var identifiers:[ListIdentifier] = []
    public func listIdentifiers() -> [ListIdentifier] {
        return identifiers
    }
    public lazy var selection: Action<IndexPath, DataValue, Error> = Action {[unowned self] input in
        
        let output = (self.modelAtIndex(input) as? DataValue)  ?? DataValue.empty
        
        
        return SignalProducer(value:output)
    }
    public required init () {}
    
    public required convenience init (data:FormData<DataValue>, title:String? = nil , itemIdentifier:ListIdentifier , dataHolder:ListDataHolderType, innerIdentifier:ListIdentifier = defaultListIdentifier , converting itemViewModelClosure:@escaping (ModelType) -> (ItemViewModelType?)) {
        self.init(model:data as ItemViewModelType.Model)
        self.title = title
        self.setup(data: data)
        self.itemIdentifier = itemIdentifier
        self.dataHolder = dataHolder
        self.identifiers = [innerIdentifier]
        self.itemViewModelClosure = itemViewModelClosure
    }
    public func itemViewModel(_ model: ModelType) -> ItemViewModelType? {
        return self.itemViewModelClosure(model)
    }
    public func toString(_ v: DataValue) -> String {
        return (v.title ?? "")
    }
    public func toValue(_ value: String) -> DataValue {
        return DataValue.empty
    }
    func setup(data:FormData<DataValue>) {
        self.string <~ data.value.map {[weak self] in self?.toString($0) ?? ""}.skipRepeats()
        //data.value <~ self.string.map {[weak self] in return (self?.toValue($0) ?? DataValue.empty)}.skipRepeats().producer.delay(0.0, on: QueueScheduler.main)
        data.value <~ self.selection.values.delay(0.0, on: QueueScheduler.main)
    }
    
    public func select(_ selection: SelectionInput) {
        guard let ip = selection as? IndexPath else {
            return
        }
        self.selection.apply(ip).start()
    }
    
}

