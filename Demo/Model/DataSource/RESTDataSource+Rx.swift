//
//  RESTDataSource+Rx.swift
//  Demo
//
//  Created by Stefano Mondino on 01/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

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
