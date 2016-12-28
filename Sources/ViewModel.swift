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

public protocol ViewModelType : class, SelectionOutput {
    init()
}

public protocol ViewModelBindable : ViewModelBindableType{
    associatedtype ViewModel = ViewModelType
    var viewModel:ViewModel? {get set}
    
}
public protocol ViewModelBindableType {
    var disposable:CompositeDisposable? {get set}
    func bind(_ viewModel: ViewModelType?)
}
extension ViewModelBindableType {
    public var disposable:CompositeDisposable? {
        get {return nil}
        set {}
    }

}

extension ViewModelType {
    public init() {
        self.init()
    }
}

public protocol SelectionInput {}
public protocol SelectionOutput {}
public enum EmptySelection : SelectionOutput{
    case empty
}

public protocol ViewModelTypeSelectable : ViewModelType {
    associatedtype Input = SelectionInput
    associatedtype Output = SelectionOutput
    
    var selection:Action<Input,Output> {get set}
    
}
public protocol ViewModelTypeActionSelectable : ViewModelType {
    func select(_ input:SelectionInput)
}
//extension ViewModelTypeSelectable {
//    func select(_ selection:Input) {
//        self.selection.apply(selection).start()
//    }
//}

public protocol ViewModelTypeLoadable : ViewModelType {
    var loading: Observable<Bool> {get set}
//    var loading: SignalProducer<Bool, NoError> {get set}
}
public protocol ViewModelTypeFailable : ViewModelType {
    var fail : Observable<Error> {get set}
//    var fail : Signal<Error, NoError> {get set}
}







