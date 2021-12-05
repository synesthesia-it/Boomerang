//
//  Game.swift
//  GameOfFifteen_iOS
//
//  Created by Stefano Mondino on 05/12/21.
//

import Foundation

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
