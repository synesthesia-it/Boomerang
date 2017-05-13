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

    var viewModels:Variable<[IndexPath:ItemViewModelType]> {get set}
    
    var resultsCount:Variable<Int> {get set}
    var isLoading:Variable<Bool> {get}

    var newDataAvailable:Variable<ResultRangeType?> {get set}

    var modelStructure : Variable<ModelStructure> {get set}

    
    var reloadAction:Action<ResultRangeType?,ModelStructure> {get set}
    var data:Observable<ModelStructure> {get set}
    func deleteItem(atIndex index:IndexPath)
    func reload()
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
    public func deleteItem(atIndex index:IndexPath) {
        let model = self.modelStructure.value
        model.deleteItem(atIndex: index)
        self.modelStructure.value = model
    }
    public init(data:Observable<ModelStructure>) {
        self.init()
        self.data = data
        self.reloadAction = Action { range in
            return data.flatMapLatest { (s:ModelStructure?) -> Observable<ModelStructure> in
                let result = (s ?? ModelStructure.empty)
                return Observable.just(result)
            }
        }
        
        reloadAction.elements.bind(to: self.modelStructure).addDisposableTo(self.disposeBag)
        self.modelStructure.asObservable().map{_ in return [IndexPath:ItemViewModelType]()}.bind(to: viewModels).addDisposableTo(self.disposeBag)
        self.modelStructure.asObservable().map { return $0.count}.bind(to: resultsCount).addDisposableTo(self.disposeBag)
        reloadAction.executing.bind(to: self.isLoading).addDisposableTo(self.disposeBag)
    }
}
public final class ListDataHolder : ListDataHolderType {
    
    public let isLoading: Variable<Bool> = Variable(false)
    public var reloadAction: Action<ResultRangeType?, ModelStructure> = Action {_ in return Observable.just(ModelStructure.empty)}
    public var modelStructure:Variable<ModelStructure> = Variable(ModelStructure.empty)
    public var viewModels:Variable = Variable([IndexPath:ItemViewModelType]())
    public var resultsCount:Variable<Int> = Variable(0)
    public var newDataAvailable:Variable<ResultRangeType?> = Variable(nil)
    public var data:Observable<ModelStructure>
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
    init()
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
            self.dataHolder.viewModels.value = d
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

