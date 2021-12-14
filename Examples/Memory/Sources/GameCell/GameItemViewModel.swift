//
//  GameItemViewModel.swift
//  GameOfFifteen_iOS
//
//  Created by Stefano Mondino on 05/12/21.
//

import Foundation
import Boomerang
import UIKit

class GameItemViewModel: ViewModel {
    enum Layout: String, LayoutIdentifier {
        case textItem
        case imageItem
    }
    let uniqueIdentifier: UniqueIdentifier

    let layoutIdentifier: LayoutIdentifier
    
    let tile: Game.Tile
    
    var description: String {
        switch tile.value{
        case let .word (text):
            
            return tile.isFlipped ? text : " "
        default : return ""
        }
    }
    
    var image: UIImage? {
        switch tile.value{
        case let .image(image): return tile.isFlipped ? image : nil
        default : return nil
        }
    }

    init(tile: Game.Tile) {
        self.tile = tile
        self.uniqueIdentifier = "\(tile.value) \(tile.order) \(tile.isFlipped)"
        switch tile.value {
        case .word :
            self.layoutIdentifier = Layout.textItem
        case .image:
            self.layoutIdentifier = Layout.imageItem
        }
    }
}
