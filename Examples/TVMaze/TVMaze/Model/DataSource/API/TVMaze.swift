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
    case searchPeople(query: String)
    case personCredit(String)
    case showDetail(String)
    var baseURL: URL {
        return URL(string: "http://api.tvmaze.com")!
    }
    
    var path: String {
        switch self {
        case .searchShows: return "search/shows"
        case .searchPeople: return "search/people"
        case .personCredit(let id): return "people/\(id)/castcredits"
        case .schedule: return "schedule"
        case .showDetail(let id): return "shows/\(id)"
        }
    }
    var queryParameters: [URLQueryItem] {
        switch self {
        case .searchShows(let query),
             .searchPeople(let query):
            return [URLQueryItem(name: "q", value: query)]
        case .personCredit: return [URLQueryItem(name: "embed", value: "show")]
        case .showDetail: return [
            URLQueryItem(name: "embed[]", value: "seasons"),
            URLQueryItem(name: "embed[]", value: "cast"),
            ]
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
