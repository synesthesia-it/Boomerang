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

public protocol ViewModelTypeSelectable : ViewModelType {
    associatedtype Input = SelectionInput
    associatedtype Output = SelectionOutput
    var selection:Action<Input,Output, Error> {get set}
    func select(selection:Input)
    
}

public protocol ViewModelTypeLoadable : ViewModelType {
    var loading: SignalProducer<Bool, NoError> {get set}
}
public protocol ViewModelTypeFailable : ViewModelType {
    var fail : Signal<Error, NoError> {get set}
}







