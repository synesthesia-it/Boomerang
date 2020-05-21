//
//  DataSource.swift
//  Demo
//
//  Created by Stefano Mondino on 24/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

protocol Task {
    func cancel()
}

protocol RESTDataSource {
    func getEntity<CodableResult: Codable>(_ entityType: CodableResult.Type,
                                           from api: TVMaze,
                                           completionHandler: @escaping (Result<CodableResult, Error>) -> Void  )
        -> Task
}

extension URLSessionDataTask: Task {}
extension URLSession {

    func getEntity<CodableResult: Codable>(
        _ entityType: CodableResult.Type,
        from api: TVMaze,
        completionHandler: @escaping (Result<CodableResult, Error>) -> Void  ) -> Task {
        let decoder: JSONDecoder = JSONDecoder()
        let task = dataTask(with: api.url) { data, _, apiError in
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
        task.resume()
        return task
    }
}
