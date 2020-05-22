//
//  TVMaze.swift
//  Demo
//
//  Created by Stefano Mondino on 24/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

enum TVMaze {
    case schedule
    case searchShows(query: String)
    var baseURL: URL {
        return URL(string: "http://api.tvmaze.com")!
    }

    var path: String {
        switch self {
        case .searchShows: return "search/shows"
        case .schedule: return "schedule"
        }
    }
    var queryParameters: [URLQueryItem] {
        switch self {
        case .searchShows(let query): return [URLQueryItem(name: "q", value: query)]
        default: return []
        }
    }
    var url: URL {
        let url = baseURL
            .appendingPathComponent(path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = queryParameters
        return components?.url ?? url
    }
}
