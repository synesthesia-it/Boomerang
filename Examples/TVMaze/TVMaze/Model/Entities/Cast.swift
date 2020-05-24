//
//  Cast.swift
//  TVMaze
//
//  Created by Stefano Mondino on 23/05/2020.
//  Copyright © 2020 Synesthesia. All rights reserved.
//

import Foundation

protocol Identity {
    var id: Int { get }
    var name: String { get }
    var image: Poster? { get }
}
struct PersonSearchResult: Codable {
    let score: Double
    let person: Person
}

struct PersonCastCreditResult: WithShow, Codable {
    private enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }
    private struct Embedded: Codable {
        let show: Show
    }
    private let embedded: Embedded
    
    var show: Show { embedded.show }
}
struct Person: Codable, Identity {
    let id: Int
    let name: String
    let image: Poster?
}

struct Cast: Codable {
    private enum CodingKeys: String, CodingKey {
        case person
        case character
        case isSelf = "self"
        case isVoice = "voice"
    }

    struct Character: Codable, Identity {
        let id: Int
        let name: String
        let image: Poster?
    }

    let person: Person
    let character: Character
    let isSelf: Bool
    let isVoice: Bool

}


