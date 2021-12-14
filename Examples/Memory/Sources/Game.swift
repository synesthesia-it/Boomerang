//
//  Game.swift
//  GameOfFifteen_iOS
//
//  Created by Stefano Mondino on 05/12/21.
//

import Foundation
import UIKit

struct Game: Equatable {
    struct Tile: Equatable {
        let value : Deck.Card
        var isFlipped : Bool = false
        let order : Int

        static func winningSequence(cards : [Deck.Card]) -> [Tile] {
            cards.flatMap{[.init(value: $0, order: 0),.init(value : $0, order: 1)]}
        }
    }
    
    enum Deck: CaseIterable  {
        case emoticons
        case alphabet
        case programmingLanguage
    
        enum Card: Equatable {
            case word (String)
            case image (UIImage?)
        }
        
        
        var name : String {
            switch self{
            case .emoticons : return "Emoji"
            case .alphabet : return "Alphabet"
            case .programmingLanguage : return "Programming Language"
            }
        }
        
        var values : [Card] {
            switch self{
            case .emoticons : return
                "😮😎😂😘😊👍😭🙈🛫😡😜❌❤️💪🏼🥶".map{.word("\($0)")}
                
            case .alphabet : return
                "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z ? !".components(separatedBy: " ")
             .map{.word ($0)}
                
            case .programmingLanguage : return [
                "c",
                "csharp",
                "html",
                "java",
                "mysql",
                "python",
                "php",
                "swift"
            ] .map{.image(UIImage(named :$0))}
            }
        }
    }
    
    private var indexStack : [Int] = []
    var elements: [Tile]
    var steps = 0
    
    var isWinning: Bool {
        return elements.first(where: {$0.isFlipped == false }) == nil
    }
    
    init (deck : Deck) {
        self.elements = Tile.winningSequence(cards: deck.values).shuffled()
    }
    
    init(elements: [Game.Tile]) {
        self.elements = elements
    }
    
    mutating func selectAt(at index: Int) {
        
        
        if elements[index].isFlipped == false {
            elements[index].isFlipped = true
            
            if indexStack.count > 1{ // on second click when noMatch is found
                indexStack.forEach {self.elements[$0].isFlipped = false}
                indexStack = []
                steps += 1
            }
            if let last = indexStack.last , elements[index].value == elements[last].value // on second click when Match is found
            {
                indexStack = []
                steps += 1
            } else {
                
                indexStack.append(index)
            }
            
        }
    }
}
