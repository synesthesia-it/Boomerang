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

struct Show: WithShow, Codable {
    let name: String
    // swiftlint:disable identifier_name
    let id: Int
    // swiftlint:enable identifier_name
    let image: Poster?
    let genres: [String]

    var show: Show { self }
}
