//
//  GameScreenViewModel.swift
//  GameOfFifteen_iOS
//
//  Created by Stefano Mondino on 05/12/21.
//

import Foundation
import Boomerang
import RxBoomerang
import RxRelay
import RxSwift

class StateGameScreenViewModel: GameScreenViewModel {

    typealias Environment = Void

    class StateMachine: RxStateMachine {
        var state: BehaviorRelay<State> = .init(value: .init(lines: 0))

        var environment: Void = ()

        lazy var reducer: (inout State, Action, Void) -> [Observable<Action>] = { state, action, _ in
            switch action {
            case let .reset(lines):
                state.game = .init(lines: lines)
                state.isWinning = state.game.isWinning
            case let .move(index):
                state.game.move(at: index)
                state.isWinning = state.game.isWinning
            }
            return []
        }

        enum Action: Equatable {
            case reset(lines: Int)
            case move(index: Int)
        }

        struct State: Equatable {
            var game: Game
            var lines: Int { game.lines }
            var isWinning: Bool
            var title: String {
                "Game of \((game.lines * game.lines))"
            }
            init(lines: Int) {

                self.game = .init(lines: lines)
                self.isWinning = false
            }
        }
    }

    enum Layout: String, LayoutIdentifier {
        case gameScreen
    }

    var sectionsRelay: BehaviorRelay<[Section]> = .init(value: [])

    var disposeBag: DisposeBag = DisposeBag()

    let uniqueIdentifier: UniqueIdentifier = UUID()

    var layoutIdentifier: LayoutIdentifier = Layout.gameScreen
    private var reloadDisposeBag = DisposeBag()

    var count: Observable<Int> {
        stateMachine.state.map(\.lines)
    }
    func update(count: Int) {
        stateMachine.send(.reset(lines: count))
    }
    let stateMachine: StateMachine
    let routes: PublishRelay<Route> = .init()
    init() {

        stateMachine = StateMachine()
        reload()
    }
    var title: Observable<String> {
        stateMachine.state.map(\.title)
    }
    func reload() {
        reloadDisposeBag = DisposeBag()
        let stateMachine = self.stateMachine
        stateMachine.state
            .asObservable()
            .map(\.game.elements)
            .distinctUntilChanged()
            .map { $0.map { GameItemViewModel(tile: $0) } }
            .map { [Section(id: "game", items: $0)] }
            .catchAndReturn([])
            .bind(to: sectionsRelay)
            .disposed(by: reloadDisposeBag)

        stateMachine.state
            .map(\.isWinning)
            .compactMap { $0 ? AlertRoute(title: "WOW!",
                                          message: "YOU WON!",
                                          actions: [.init(title: "OK",
                                                          callback: {
                stateMachine.send(.reset(lines: stateMachine.state.value.lines))
            })]) : nil}

            .bind(to: routes)
            .disposed(by: reloadDisposeBag)
    }

    func selectItem(at indexPath: IndexPath) {
        self.stateMachine.send(.move(index: indexPath.item))
    }

    func elementSize(at indexPath: IndexPath, type: String?) -> ElementSize? {
        guard type == nil else { return nil }
        return Size.aspectRatio(1, itemsPerLine: stateMachine.state.value.lines)
    }

    func sectionProperties(at index: Int) -> Size.SectionProperties {
        .init(insets: .init(top: 20, left: 4, bottom: 4, right: 4),
              lineSpacing: 4,
              itemSpacing: 4)
    }
}
