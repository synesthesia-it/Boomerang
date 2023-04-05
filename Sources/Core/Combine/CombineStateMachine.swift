import Foundation
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol CombineStateMachine: AnyObject {
    associatedtype State: Equatable
    associatedtype Action: Equatable
    associatedtype Environment

    var state: CurrentValueSubject<State, Never> { get }
    var environment: Environment { get }
    var cancellables: [AnyCancellable] { get set }
    var reducer: (inout State, Action, Environment) -> [AnyPublisher<Action, Never>] { get }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension CombineStateMachine {
    func send(_ action: Action) {
        var valueCopy = state.value
        let effects = reducer(&valueCopy, action, environment)

        state.send(valueCopy)
        
        Publishers.MergeMany(effects)
            .sink(receiveValue: { [weak self] in self?.send($0) })
            .store(in: &cancellables)

    }
}
