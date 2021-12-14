//
//  StateMachine.swift
//  Memory_iOS
//
//  Created by Andrea De vito on 13/12/21.
//

import Foundation
import Boomerang
import RxBoomerang
import RxRelay
import RxSwift

class StateMachine: RxStateMachine {
    typealias Environment = Void
    var state: BehaviorRelay<State> = .init(value: .init(count: 0, deck: .alphabet))

    var environment: Void = ()

    lazy var reducer: (inout State, Action, Void) -> [Observable<Action>] = { state, action, _ in
        switch action {
        case let .reset(lines):
            state.game = .init(deck : state.deck)
            state.isWinning = state.game.isWinning
        case let .move(index):
            state.game.selectAt(at: index)
            state.isWinning = state.game.isWinning
        case .choose(deck: let deck):
            state.game = .init(deck : deck)
            state.deck = deck
        }
        return []
    }
    


    enum Action: Equatable {
        case reset(lines: Int)
        case move(index: Int)
        case choose(deck : Game.Deck)
    }

    struct State: Equatable {
        var deck: Game.Deck
        var game: Game
        var count: Int { Int (game.elements.count / 2) }
        var isWinning: Bool
        var title: String {
            "Memory \((count))"
        }
        init(count: Int, deck: Game.Deck) {
            self.game = .init(deck: deck)
            self.isWinning = false
            self.deck = deck
        }
    }
}
