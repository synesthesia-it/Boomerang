//
//  ViewModel.swift
//  Boomerang
//
//  Created by Stefano Mondino on 13/10/16.
//
//

import Foundation
import RxSwift
import RxCocoa
import Action

//public struct Error : Swift.Error {
//    public var error:Swift.Error
//    public init(error:Swift.Error) {
//        self.error = error
//    }
//}

/** A generic ViewModel element in MVVM pattern
 
    Base implementation is empty as long as the implementing object is a class.
    Structs and enums are not allowed to implement this protocol since (in Boomerang) a ViewModel object can be shared between more than one view as the same time.
 */
public protocol ViewModelType: class {}

/**
 An object that can be bound to a viewModel.
 */
public protocol ViewModelBindableType {
    var disposeBag: DisposeBag { get }
    func bind(to viewModel: ViewModelType?)
}

/**
 An object (usually, a view or a view controller) that can be bound to a viewModel.
 Since `viewModel` is declared through an associatedtype, ViewModelBindable and ViewModelBindableType are kept separated to allow `ViewModelBindableType` typecasts through Boomerang's codebase.
 
 **IMPORTANT**
 When ViewModelBindable protocol is implemented, ViewModels must be retained somewhere: the `viewModel` variable should be used for this purpose.
 */
public protocol ViewModelBindable: ViewModelBindableType {
    associatedtype ViewModel = ViewModelType
    var viewModel: ViewModel? {get set}
}

private struct AssociatedKeys {
    static var disposeBag = "disposeBag"
}

//extension BehaviorRelay : ModelType {}

extension ViewModelType {
    /**
     A useful, lazily-created disposeBag where disposables can be easily stored.
     */
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

/**
 Convenience protocol used to identify some view model that *loads* something.
 */
public protocol ViewModelTypeLoadable: ViewModelType {
    var loading: Observable<Bool> {get set}
}

/**
 Convenience protocol used to identify some view model whose actions can *fail*
 */

public protocol ViewModelTypeFailable: ViewModelType {
    var fail: Observable<Error> {get set}
}

/**
 Typealias for `Observable<Error?>`
 */
public typealias ObservableError = Observable<Swift.Error?>

/**
    Previously used to pass some style informations to Form view models.
    Due to increasing complexity, Form items are out of Boomerang's scope.
 */

@available(*, deprecated, message: "Boomerang dropped Form support as they were out of scope. Declare this protocol directly in your codebase if needed")
public protocol FormStyle: class {}
