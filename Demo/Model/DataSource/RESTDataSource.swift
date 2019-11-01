//
//  DataSource.swift
//  Demo
//
//  Created by Stefano Mondino on 24/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
protocol Task {
    func cancel()
}

protocol RESTDataSource {
    func getEntity<CodableResult: Codable>(_ entityType: CodableResult.Type, from api: TVMaze, completionHandler: @escaping (Result<CodableResult,Error>) -> ()  ) -> Task
}

extension URLSessionDataTask: Task {}
extension URLSession {
    
    func getEntity<CodableResult: Codable>(
        _ entityType: CodableResult.Type,
        from api: TVMaze,
        completionHandler: @escaping (Result<CodableResult,Error>) -> ()  ) -> Task {
        let decoder: JSONDecoder = JSONDecoder()
        let task = dataTask(with: api.url) { data, response, apiError in
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

extension Reactive where Base: URLSession {
    func getEntity<CodableResult: Codable>(
        _ entityType: CodableResult.Type,
        from api: TVMaze) -> Observable<CodableResult> {
        return Observable<CodableResult>.create { observer in
            let task = URLSession.shared.getEntity(CodableResult.self, from: api) { result in
                switch result {
                case .success(let episodes):
                    observer.onNext(episodes)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
