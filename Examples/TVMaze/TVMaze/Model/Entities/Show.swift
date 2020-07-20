//
//  Show.swift
//  Demo
//
//  Created by Stefano Mondino on 24/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

protocol WithShow {
    var show: Show { get }
}

struct Episode: WithShow, Codable {
    let name: String
    let show: Show
    let image: Poster?
}
struct ShowSearchResult: WithShow, Codable {
    let score: Double
    let show: Show
}

struct Poster: Codable {
    let medium: URL
    let original: URL
}

struct Season: Codable {
    let id: Int
    let number: Int
    let image: Poster?
}

struct Show: WithShow, Codable {
    private struct Embedded: Codable {
        let seasons: [Season]?
        let cast: [Cast]?
    }

    let name: String
    // swiftlint:disable identifier_name
    let id: Int
    // swiftlint:enable identifier_name
    let image: Poster?
    let genres: [String]

    var show: Show { self }

    private let _embedded: Embedded?

    var cast: [Cast] { _embedded?.cast ?? [] }
    var seasons: [Season] { _embedded?.seasons ?? [] }
}
