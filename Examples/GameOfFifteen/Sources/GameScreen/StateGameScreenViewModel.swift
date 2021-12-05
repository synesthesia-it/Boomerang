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

struct Game: Equatable {
    enum Tile: Equatable {
        case empty
        case value(Int)
        
        init(number: Int?) {
            if let number = number {
                self = .value(number)
            } else {
                self = .empty
            }
        }
        static func winningSequence(lines: Int) -> [Tile] {
            (1..<(lines * lines)).map { Tile.value($0) } + [.empty]
        }
        var isEmpty: Bool { return self == .empty }
    }
    var lines: Int {
        Int(sqrt(Double(elements.count)))
    }
    var elements: [Tile]
    
    var winningGame: Game {
        return Game(elements: Tile.winningSequence(lines: lines))
    }
    
    var isWinning: Bool {
        self == winningGame
    }
    init(lines: Int) {
        self.elements = Tile.winningSequence(lines: max(1, lines)).shuffled()
    }
    
    init(elements: [Game.Tile]) {
        self.elements = elements
    }
    
    mutating func move(at index: Int) {
        guard let emptyIndex = elements.firstIndex(where: { $0.isEmpty }) else { return }
        // same column when distance is less or equal than elements on a row and module is same
        let sameColumn = ((abs(emptyIndex - index) <= lines) && ((emptyIndex % lines) == (index % lines)))
        let sameLine = (abs(emptyIndex - index) < 2 && (emptyIndex / lines) == (index / lines))
        if sameLine || sameColumn {
            self.elements.swapAt(index, emptyIndex)
        }
    }
}

class StateGameScreenViewModel: GameScreenViewModel {
    
    typealias Environment = Void
    
    class StateMachine: RxStateMachine {
        var state: BehaviorRelay<State> = .init(value: .init(lines: 0))
        
        var environment: Void = ()
        
        lazy var reducer: (inout State, Action, Void) -> [Observable<Action>] = { state, action, environment in
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
    
    init() {
                
        stateMachine = StateMachine()
        reload()
    }
    var title: Observable<String> {
        stateMachine.state.map(\.title)
    }
    func reload() {
        reloadDisposeBag = DisposeBag()
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
            .map { $0 ? "WON!" : "" }
            .debug()
            .subscribe()
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
