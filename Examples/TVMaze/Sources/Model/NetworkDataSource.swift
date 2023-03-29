//
//  Controller.swift
//  TVMaze
//
//  Created by Andrea De vito on 08/10/21.
//

import Foundation
import RxSwift
enum Errors: Error {
    case noConnection
    case http(Int)
    case mapping
}

protocol NetworkDataSource {
    func codable<Value: Codable>(at url: URL, type: Value.Type) -> Observable<Value>
}

class NetworkDataSourceImplementation: NetworkDataSource {
    func codable<Value>(at url: URL, type: Value.Type) -> Observable<Value> where Value: Decodable, Value: Encodable {
        URLSession.shared.rx.codable(at: url, type: type)

    }
    init() {}

}

class MockedNetworkDownloader: NetworkDataSource {
    init<Value: Codable>(JSONString: String, type: Value.Type) {
       let data = JSONString.data(using: .utf8)!
        do {  let result = try JSONDecoder()
            .decode(type, from: data)
        self.observable = .just(result)
        } catch {
            self.observable = .error(Errors.mapping)
        }
    }

    internal init(observable: Observable<Any>) {
        self.observable = observable
    }

    let observable: Observable<Any>
    func codable<Value>(at url: URL, type: Value.Type) -> Observable<Value> where Value: Decodable, Value: Encodable {
        return observable
            .compactMap {
                $0 as? Value
            }
    }
}

extension Reactive where Base == URLSession {
    func codable<Value: Codable>(at url: URL, type: Value.Type = Value.self) -> Observable<Value> {
        data(request: .init(url: url)).map { data in
            do {
                let decoder = JSONDecoder()
                let value = try decoder.decode(Value.self, from: data)
                return value
            } catch {
                print(error)
                throw Errors.mapping
            }
        }
    }
}

//
// class NetworkDownloader<Value: Codable>: ReactiveCompatible {
//
//
//
//    private var task: URLSessionDataTask?
//
//    deinit {
//        task?.cancel()
//    }
//
//    func start(url: URL, completion callback: @escaping (Result<Value, Errors>) -> Void) {
//
//        task?.cancel()
//        task = URLSession.shared.dataTask(with: url) {  data, response, error in
//           // DispatchQueue.main.async {
//                if let error = error {
//                    print(error)
//                    callback(.failure(.noConnection))
//                }
//                if let response = response as? HTTPURLResponse, response.statusCode >= 400{
//                    callback(.failure(.http(response.statusCode)))
//                }
//                guard let data = data else {
//                    callback(.failure(.mapping))
//                    return
//                }
//
//                do {
//                    let decoder = JSONDecoder()
//                    let value = try decoder.decode(Value.self, from: data)
//                    callback(.success(value))
//                } catch {
//                    print(error)
//                    callback(.failure(.mapping))
//                }
//       //     }
//        }
//        task?.resume()
//    }
//
//
//    func codable(for url: URL) -> Observable<Value>{
//        Observable.create{ observer in
//            self.start(url: url) { result in
//                switch result {
//                case .success(let value):
//                    observer.onNext(value)
//                    observer.onCompleted()
//
//                case .failure(let value):
//                    observer.onError(value)
//                }
//            }
//            return Disposables.create {
//                self.task?.cancel()
//            }
//        }
//    }
// }
