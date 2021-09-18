//
//  StateMachineTests.swift
//  Boomerang
//
//  Created by Stefano Mondino on 18/09/21.
//

import Foundation
import XCTest
@testable import RxBoomerang
import RxSwift
import RxRelay

class RxStateMachineTests: XCTestCase {
    class StateMachine: RxStateMachine {
        let state: BehaviorRelay<State> = .init(value: .empty)
        
        var environment: Environment = .init()
        
        lazy var reducer: (inout State, Action, Environment) -> [Observable<Action>] = { state, action, environment in
            switch action {
            case .reload:
                state.title = environment.name
                return []
            case .reset:
                state = .empty
                return []
            case .loadAndReset:
                
                return [
                    .just(.reload),
                    Observable.just(.reset).delaySubscription(.seconds(2), scheduler: MainScheduler.instance)]
            }
        }
        
        enum Action: Equatable {
            case reload
            case reset
            case loadAndReset
        }
        
        struct Environment {
            let name = "Boomerang"
        }
        
        struct State: Equatable {
            var title: String
            
            static var empty: State {
                .init(title: "")
            }
        }
    }
    
    func testStateUpdate() {
        let stateMachine = StateMachine()
        assert(stateMachine, steps:
                    .init(.send, .reload) {
            $0.title = "Boomerang"
        }
        )
    }
    func testLoadAndReset() {
        let stateMachine = StateMachine()
        assert(stateMachine, steps:
               Step(.send, .loadAndReset) { _ in },
               Step(.receive, .reload) { $0.title = "Boomerang" },
               Step(.receive, .reset) { $0.title = "" },
               Step(.sendSync, .loadAndReset) { _ in}
        )
    }
    
}

public enum StepType {
    case send
    case sendSync
    case receive
}

public struct Step<Value, Action> {
    let type: StepType
    let action: Action
    let update: (inout Value) -> Void
    let file: StaticString
    let line: UInt
    
    public init(
        _ type: StepType,
        _ action: Action,
        file: StaticString = #file,
        line: UInt = #line,
        _ update: @escaping (inout Value) -> Void
    ) {
        self.type = type
        self.action = action
        self.update = update
        self.file = file
        self.line = line
    }
}

public func assert<StateMachine: RxStateMachine>(
    _ stateMachine: StateMachine,
    steps: Step<StateMachine.State, StateMachine.Action>...,
                                                     file: StaticString = #file,
                                                     line: UInt = #line) {
                                                         
                                                         assert(initialValue: stateMachine.state.value,
                                                                reducer: stateMachine.reducer,
                                                                environment: stateMachine.environment,
                                                                steps: steps,
                                                                file: file,
                                                                line: line)
}

public func assert<State: Equatable, Action: Equatable, Environment>(
    initialValue: State,
    reducer: @escaping(inout State, Action, Environment) -> [Observable<Action>],
    environment: Environment,
    steps: Step<State, Action>...,
    file: StaticString = #file,
    line: UInt = #line
) {
    assert(initialValue: initialValue,
           reducer: reducer,
           environment: environment,
           steps: steps,
           file: file,
           line: line)
}

public func assert<State: Equatable, Action: Equatable, Environment>(
    initialValue: State,
    reducer: @escaping(inout State, Action, Environment) -> [Observable<Action>],
    environment: Environment,
    steps: [Step<State, Action>],
    file: StaticString = #file,
    line: UInt = #line
) {
    var state = initialValue
    var effects: [Observable<Action>] = []
    let disposeBag = DisposeBag()
    
    steps.forEach { step in
        var expected = state
        
        switch step.type {
        case .send:
            if effects.isEmpty == false {
                XCTFail("Action sent before handling \(effects.count) pending effect(s)", file: step.file, line: step.line)
            }
        
            effects.append(contentsOf:reducer(&state, step.action, environment))
            
        case .receive:
            guard effects.isEmpty == false else {
                XCTFail("No pending effects to receive from", file: step.file, line: step.line)
                break
            }
            
            let effect = effects.removeFirst()
            var action: Action!
            let receivedCompletion = XCTestExpectation(description: "receivedCompletion")
            
            effect
                .subscribe(
                    onNext: { action = $0 },
                    onCompleted: { receivedCompletion.fulfill() })
                .disposed(by: disposeBag)
            
            if XCTWaiter.wait(for: [receivedCompletion], timeout: 5) != .completed {
                XCTFail("Timed out waiting for the effect to complete", file: step.file, line: step.line)
            }
            
            XCTAssertEqual(action, step.action, file: step.file, line: step.line)
            
            effects.append(contentsOf: reducer(&state, action, environment))
            
        case .sendSync:
            if effects.isEmpty == false {
                XCTFail("Action sent before handling \(effects.count) pending effect(s)", file: step.file, line: step.line)
            }
            
            effects = []
        }
        
        step.update(&expected)
        
        XCTAssertEqual(expected, state, file: step.file, line: step.line)
    }
    
    if effects.isEmpty == false {
        XCTFail("Assertion failed to handle \(effects.count) pending effect(s)", file: file, line: line)
    }
}
