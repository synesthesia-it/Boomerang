//
//  GameItemViewModel.swift
//  GameOfFifteen_iOS
//
//  Created by Stefano Mondino on 05/12/21.
//

import Foundation
import Boomerang

class GameItemViewModel: ViewModel {
    enum Layout: String, LayoutIdentifier {
        case gameItem
        case imageItem
    }
    let uniqueIdentifier: UniqueIdentifier

    let layoutIdentifier: LayoutIdentifier

    var number: Int? {
        switch tile {
        case let .value(value): return value
        default: return nil
        }
    }
    
    let tile: Game.Tile
    let description: String
    var isEmpty: Bool { number == nil }

    convenience init(number: Int?) {
        self.init(tile: .init(number: number))
    }

    init(tile: Game.Tile) {
        self.tile = tile
        switch tile {
//        case .empty: description = ""
        case let .value(value): description = "\(value)"
        }

        self.uniqueIdentifier = description
        self.layoutIdentifier = Deck == .alphabet ? Layout.gameItem : Layout.imageItem
    }
}
