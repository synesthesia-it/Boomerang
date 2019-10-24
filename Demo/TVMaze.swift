//
//  TVMaze.swift
//  Demo
//
//  Created by Stefano Mondino on 24/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

enum TVShow {
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

extension URLSession {
    func task<CodableResult: Codable>(
                                      _ class: CodableResult.Type,
                                      api: TVShow,
                                      decoder: JSONDecoder = JSONDecoder(),
                                      completionHandler: @escaping (Result<CodableResult,Error>) -> ()  ) -> URLSessionDataTask {
        
        return dataTask(with: api.url) { data, response, apiError in
            if let error = apiError {
                completionHandler(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let decoded = try decoder.decode(CodableResult.self, from: data)
                completionHandler(.success(decoded))
                return
            } catch let error {
                completionHandler(.failure(error))
                return
            }
    
        }
    }
}
