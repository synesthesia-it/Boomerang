//
//  Show.swift
//  Demo
//
//  Created by Stefano Mondino on 24/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

struct Episode: Codable {
    let name: String
    let show: Show
    let image: Poster?
}

struct Poster: Codable {
    let medium: URL
    let original: URL
}

struct Show: Codable {
    let name: String
    let id: Int
    // swiftlint:enable identifier_name
    let image: Poster?
    let genres: [String]
}
