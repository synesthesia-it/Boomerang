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




public protocol ViewModelType : class {
    init()
}

public protocol ViewModelBindable : ViewModelBindableType{
    associatedtype ViewModel = ViewModelType
    var viewModel:ViewModel? {get set}
    
}
public protocol ViewModelBindableType {
    var disposable:CompositeDisposable? {get set}
    func bindViewModel(_ viewModel: ViewModelType?)
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







