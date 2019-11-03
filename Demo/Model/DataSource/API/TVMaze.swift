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

    var baseURL: URL {
        return URL(string: "http://api.tvmaze.com")!
    }

    var path: String {
        switch self {
        case .schedule: return "schedule"
        }
    }

    var url: URL {
        return baseURL.appendingPathComponent(path)
    }
}
