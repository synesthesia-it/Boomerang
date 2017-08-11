//
//  FormViewModel.swift
//  Boomerang
//
//  Created by Stefano Mondino on 21/11/16.
//
//

import Foundation
//import ReactiveSwift
import RxSwift
import RxCocoa
import Action

public protocol FormValue   {
    var title:String? {get}
    //static var empty: Self {get}
}
extension FormValue {
    public var title:String? {
        return nil
    }
    
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
    
    var value:Variable<Value> {get}
}

extension Variable : ModelType {
    
}
public typealias FormData<T> = Variable<T>

//public class FormData<Value : FormValueEquatable> : FormDataMutableType {
//    public var reference : FormDataReference
//    public var title: String? {
//        return self.reference.key
//    }
//    public var value:Variable<Value> = Variable<Value>(Value.empty)
//    public init(reference:FormDataReference, initialValue:Value = Value.empty) {
//        self.reference = reference
//        self.value.value = initialValue
//    }
//    public func getValue() -> Any {
//        return self.value.value
//    }
//}

public protocol TextInput : ViewModelType {
    var title:String? {get}
    var string:Variable<String> {get set}
}

public protocol FormItemViewModel : ItemViewModelType, ModelType {
    associatedtype DataValue : FormValue
    
    var error:ObservableError? {get}
    init(data:FormData<DataValue>)
}
private struct AssociatedKeys {
    
    static var DisposeBag = "disposeBag"
    
}
extension FormItemViewModel {
    
    public var disposeBag: DisposeBag {
        var disposeBag: DisposeBag
        
        if let lookup = objc_getAssociatedObject(self, &AssociatedKeys.DisposeBag) as? DisposeBag {
            disposeBag = lookup
        } else {
            disposeBag = DisposeBag()
            objc_setAssociatedObject(self, &AssociatedKeys.DisposeBag, disposeBag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        return disposeBag
    }
    public var title: String? {
        return nil
    }
//    func setup(data:FormData<DataValue>) {
//        self.model = data
//        let bag = self.disposeBag
//        data.value.asObservable().map {[weak self] in self?.toString($0) ?? ""}.distinctUntilChanged().bindTo(string).addDisposableTo(bag)
//        self.string.asObservable().delay(0.0, scheduler: MainScheduler.instance).map {[weak self] in self?.toValue($0) ?? DataValue.empty}.bindTo(data.value).addDisposableTo(bag)
//        
//    }
//    public init(data:FormData<DataValue>) {
////        self.init(model:data)
//        
//        self.model = data
//        
//    }
}


public protocol FormViewModelType : ListViewModelType {
    //func formData() -> [String : Any]
}

extension FormViewModelType {
    public func formData() -> [String : Any] {
        //        return self.dataHolder.models.value.
        return self.dataHolder.modelStructure.value.allData()
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
public protocol FormStyle: class {
    
}
public typealias ObservableError = Observable<Swift.Error?>
extension String :FormValueEquatable {
    public static var empty: String = ""
}
open class StringFormItemViewModel : FormItemViewModel , TextInput{


    public typealias DataValue = String
    public static var defaultItemIdentifier: ListIdentifier = defaultListIdentifier
    public var string:Variable<String> = Variable("")
    public var itemIdentifier: ListIdentifier = StringFormItemViewModel.defaultItemIdentifier
    public var model:ItemViewModelType.Model = FormData<DataValue>(DataValue.empty)
    public var value:Variable<DataValue> {
        return self.model as? FormData<DataValue> ?? FormData<DataValue>(DataValue.empty)
    }
    public var title: String?
    public var style: FormStyle?
    public var error:ObservableError?
    
    public required init (data: Variable<String>) {
        self.model = data
    }
    public required convenience init (data:FormData<DataValue>,
                                      title:String? = nil,
                                      itemIdentifier:ListIdentifier = StringFormItemViewModel.defaultItemIdentifier,
                                      error:ObservableError? = nil,
                                      style:FormStyle? = nil
                                      ) {
        self.init(data:data )
        self.title = title
        self.style = style
        self.error = error
        self.string = data
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
    public var string:Variable<String> = Variable("")
    public var itemIdentifier: ListIdentifier = BoolFormItemViewModel.defaultItemIdentifier
    public var model:ItemViewModelType.Model = FormData<DataValue>(DataValue.empty)
    public var value:Variable<DataValue> = Variable(DataValue.empty)
    public var title: String?
    public var error:ObservableError?
    public required init (data: Variable<Bool>) {
        self.model = data
    }
    public required convenience init (data:FormData<DataValue>, title:String? = nil, itemIdentifier:ListIdentifier = BoolFormItemViewModel.defaultItemIdentifier, error:ObservableError? = nil) {
        self.init(data:data)
        self.title = title
        self.itemIdentifier = itemIdentifier
        self.error = error
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
    public var itemIdentifier: ListIdentifier = IntFormItemViewModel.defaultItemIdentifier
    public var model:ItemViewModelType.Model = FormData<DataValue>(DataValue.empty)
    public var value:Variable<DataValue> = Variable(DataValue.empty)
    public var title: String?
    public var error: ObservableError?
    public required init (data: Variable<Int>) {
        self.model = data
    }
    public required convenience init (data:FormData<DataValue>, title:String? = nil , itemIdentifier:ListIdentifier = IntFormItemViewModel.defaultItemIdentifier, error:ObservableError? = nil) {
        self.init(data:data )
        self.title = title
        self.error = error
        self.itemIdentifier = itemIdentifier
    }
    public func toString(_ value: DataValue) -> String {
        return String(value)
    }
    public func toValue(_ value: String) -> DataValue {
        return Int(value) ?? DataValue.empty
    }
}

public protocol FormModelType : FormValue, ModelType, SelectionInput, SelectionOutput {
//    var title:String? {get}
    
}

private class EmptyModel:ModelType{}
public class FormModel : FormModelType {
    
    public static var empty: FormModel = FormModel(model: EmptyModel())
    var model:ModelType
    init(model:ModelType) {
        self.model = model
    }
}
open class MultiselectionItemViewModel<DataValue:FormModel> : FormItemViewModel, ListViewModelType, ViewModelTypeSelectable, ViewModelTypeActionSelectable {
    public typealias DataValue = FormModel
    
    public var string: Variable<String> = Variable("")
    public var title:String?
    public var itemIdentifier: ListIdentifier  = defaultListIdentifier
    public var dataHolder: ListDataHolderType = ListDataHolder()
    public var model:ItemViewModelType.Model = FormData<DataValue>(DataValue.empty)
    public var itemViewModelClosure: (ModelType) -> (ItemViewModelType?)  = {_ in return nil}
    private var identifiers:[ListIdentifier] = []
    public var error: ObservableError?
    public var listIdentifiers : [ListIdentifier] {
        return identifiers
    }
    public lazy var selection: Action<IndexPath, DataValue> = Action {[unowned self] input in
        
        guard let output = ((self.model(atIndex:input) ) as? DataValue) else {
            return .empty()
        }
        return .just(output)
    }
    public required init (data: Variable<DataValue>) {
        self.model = data
    }
    required public init() {
        
    }
    public required convenience init (data:FormData<DataValue>, title:String? = nil , itemIdentifier:ListIdentifier , dataHolder:ListDataHolderType, innerIdentifier:ListIdentifier = defaultListIdentifier, error:ObservableError? , converting itemViewModelClosure:@escaping (ModelType) -> (ItemViewModelType?)) {
        self.init(data:data)
        self.title = title
        self.itemIdentifier = itemIdentifier
        self.error = error
        self.dataHolder = dataHolder
        self.identifiers = [innerIdentifier]
        self.itemViewModelClosure = itemViewModelClosure
    }
    public func itemViewModel(fromModel model: FormModel) -> ItemViewModelType? {
        return self.itemViewModelClosure(model.model)
    }
//    public func toString(_ v: DataValue) -> String {
//        return (v.title ?? "")
//    }
//    public func toValue(_ value: String) -> DataValue {
//        return DataValue.empty
//    }
//    func setup(data:FormData<DataValue>) {
//        
//        
//        data.value.asObservable().map {[weak self] in self?.toString($0) ?? ""}.distinctUntilChanged().bindTo(string).addDisposableTo(self.disposeBag)
//        self.selection.executionObservables.switchLatest().delay(0.0, scheduler: MainScheduler.instance).bindTo(data.value).addDisposableTo(self.disposeBag)
//    }
    
    public func select(withInput selection: SelectionInput) {
        guard let ip = selection as? IndexPath else {
            return
        }
        self.selection.execute(ip)
        
    }
    
}



public class FormValueWrapper<Type:ModelType>: ModelType, FormValue {
    public static var empty: FormValueWrapper {return FormValueWrapper(nil)}
    public var value:Type?
    public init(_ value:Type?) {
        self.value = value
    }
}


public protocol PickerViewModelType : ViewModelType {
    var pickedItem:Variable<ModelType?> {get}
}


open class ModelFormItemViewModel<T:ModelType> : FormItemViewModel{
    
    
    
    public typealias DataValue = FormValueWrapper<T>
    
    public func with(picker:PickerViewModelType) -> ModelFormItemViewModel<T> {
        self.picker = picker
        (picker.pickedItem.asObservable().map {$0 as? T}.filter{$0 != nil}).map {FormValueWrapper($0!)}.bind(to: self.value).addDisposableTo(self.disposeBag)
        return self
    }
    public var picker:PickerViewModelType?
    
    //static var defaultItemIdentifier: ListIdentifier = ""//defaultListIdentifier
    public var itemIdentifier: ListIdentifier = StringFormItemViewModel.defaultItemIdentifier
    public var model:ItemViewModelType.Model = FormData<DataValue>(DataValue.empty)
    public var value:Variable<DataValue> {
        return self.model as? FormData<DataValue> ?? FormData<DataValue>(DataValue.empty)
    }
    public var title: String?
    public var style: FormStyle?
    public var error:ObservableError?
    public required init (data: Variable<DataValue>) {
        self.model = data
    }
    public required init (data:FormData<DataValue>,
                   title:String? = nil,
                   itemIdentifier:ListIdentifier,
                   error:ObservableError? = nil,
                   style:FormStyle? = nil
        ) {
        self.model = data
        self.title = title
        self.style = style
        self.error = error
        self.itemIdentifier = itemIdentifier
    }
}
