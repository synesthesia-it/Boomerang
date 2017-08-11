//
//  ViewModel.swift
//  Boomerang
//
//  Created by Stefano Mondino on 13/10/16.
//
//

import Foundation
import RxSwift
import Action


//public typealias ListIdentifier = String



public struct Error : Swift.Error {
    public var error:Swift.Error
    public init(error:Swift.Error) {
        self.error = error
    }
}

public protocol ViewModelType : class {
//    init()
}

public protocol ViewModelBindable : ViewModelBindableType{
    associatedtype ViewModel = ViewModelType
    var viewModel:ViewModel? {get set}
    
}
public protocol ViewModelBindableType {
    var disposeBag:DisposeBag {get}
    func bind(to viewModel: ViewModelType?)
}
extension ViewModelBindableType {}
private struct AssociatedKeys {
    static var disposeBag = "disposeBag"
}
extension ViewModelType {
//    public init() {
//        self.init()
//    }
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
}

public protocol SelectionInput {}
public protocol SelectionOutput {}
public enum EmptySelection : SelectionOutput{
    case empty
}


public protocol ViewModelTypeIdentifiable : ViewModelType {
    var itemIdentifier:ListIdentifier { get }
}

public protocol ViewModelTypeSelectable : ViewModelType {
    associatedtype Input = SelectionInput
    associatedtype Output = SelectionOutput
    
    var selection:Action<Input,Output> {get set}
    
}
public protocol ViewModelTypeActionSelectable : ViewModelType {
    func select(withInput input:SelectionInput)
}
//extension ViewModelTypeSelectable {
//    func select(_ selection:Input) {
//        self.selection.apply(selection).start()
//    }
//}

public protocol ViewModelTypeLoadable : ViewModelType {
    var loading: Observable<Bool> {get set}
}
public protocol ViewModelTypeFailable : ViewModelType {
    var fail : Observable<Error> {get set}
}







