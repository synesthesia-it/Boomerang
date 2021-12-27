//
//  RxStateMachine.swift
//  Boomerang
//
//  Credits to pointfree.co for the original idea (composable architecture) and implementation
//

import Foundation
import RxRelay
import RxSwift

public protocol RxStateMachine: AnyObject {
    associatedtype State: Equatable
    associatedtype Action: Equatable
    associatedtype Environment

    var state: BehaviorRelay<State> { get }
    var environment: Environment { get }
    
    var reducer: (inout State, Action, Environment) -> [Observable<Action>] { get }
}

public extension RxStateMachine {
    func send(_ action: Action, disposeBag: DisposeBag = DisposeBag()) {
        var valueCopy = state.value
        let effects = reducer(&valueCopy, action, environment)

        state.accept(valueCopy)
        Observable
            .merge(effects)
            .bind { [weak self] in self?.send($0, disposeBag: disposeBag) }
            .disposed(by: disposeBag)
    }
}
