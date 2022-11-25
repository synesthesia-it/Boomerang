//
//  RxNavigationViewModel+Utilities.swift
//  TestUtilities
//
//  Created by Stefano Mondino on 20/09/21.
//

import Foundation
import RxBlocking
import RxSwift
import XCTest
import Boomerang
#if !COCOAPODS_RXBOOMERANG
import RxBoomerang
#endif

public func assertRoute<Identifier, Stream: ObservableType>(_ stream: Stream,
                                                            targets: [Identifier],
                                                            timeout: TimeInterval? = routesTimeout,
                                                            file: StaticString = #filePath,
                                                            line: UInt = #line,
                                                            comparer: (Identifier, Identifier) throws -> Bool) rethrows where Stream.Element == Route {
    let values = stream
        .toBlocking(timeout: timeout)
        .materialize()
        .values
    guard let routes = values
            as? [MockRoute<Identifier>]
    else {
        XCTFail("Route is not testable: found \(values), expected identifier: \(Identifier.self)", file: file, line: line)
        return
    }
    guard routes.count == targets.count else {
        XCTFail("Expected \(targets.count) routes (\(targets)), but found \(routes.count) routes ((\(routes))")
        return
    }
    try zip(routes.map { $0.identifier}, targets).forEach {
        XCTAssertTrue(try comparer($0, $1), file: file, line: line)
    }
}
public func assertRoute<Stream: ObservableType,
                        Identifier>(_ stream: Stream,
                                    targeting targets: [Identifier],
                                    timeout: TimeInterval? = routesTimeout,
                                    file: StaticString = #filePath,
                                    line: UInt = #line) where Stream.Element == Route, Identifier: Equatable {
    assertRoute(stream,
                targets: targets,
                timeout: timeout,
                file: file,
                line: line,
                comparer: { $0 == $1 })
}

public func assertRoute<Stream: ObservableType,
                        Identifier>(_ stream: Stream,
                                    target: Identifier,
                                    timeout: TimeInterval? = routesTimeout,
                                    file: StaticString = #filePath,
                                    line: UInt = #line,
                                    comparer: (Identifier, Identifier) throws -> Bool) rethrows where Stream.Element == Route {
    try assertRoute(stream,
                    targets: [target],
                    timeout: timeout,
                    file: file,
                    line: line,
                    comparer: comparer)
}

public func assertRoute<Stream: ObservableType,
                        Identifier>(_ stream: Stream,
                                    targeting target: Identifier,
                                    timeout: TimeInterval? = routesTimeout,
                                    file: StaticString = #filePath,
                                    line: UInt = #line) where Stream.Element == Route, Identifier: Equatable {
    assertRoute(stream, targeting: [target], timeout: timeout, file: file, line: line)
}

public func assertRoute<Identifier, ViewModel: RxNavigationViewModel>(_ viewModel: ViewModel,
                                                                      target: Identifier,
                                                                      timeout: TimeInterval? = routesTimeout,
                                                                      file: StaticString = #filePath,
                                                                      line: UInt = #line,
                                                                      comparer: (Identifier, Identifier) throws -> Bool,
                                                                      starting callback: @escaping (ViewModel) throws -> Void) rethrows {
    try assertRoute(viewModel,
                    targets: [target],
                    timeout: timeout,
                    file: file,
                    line: line,
                    comparer: comparer,
                    starting: callback)
}
public func assertRoute<Identifier: Equatable, ViewModel: RxNavigationViewModel>(_ viewModel: ViewModel,
                                                                                 targeting target: Identifier,
                                                                                 timeout: TimeInterval? = routesTimeout,
                                                                                 file: StaticString = #filePath,
                                                                                 line: UInt = #line,
                                                                                 starting callback: @escaping (ViewModel) throws -> Void) rethrows {
    try assertRoute(viewModel,
                    target: target,
                    timeout: timeout,
                    file: file,
                    line: line,
                    comparer: { $0 == $1 },
                    starting: callback)
}

public func assertRoute<Identifier, ViewModel: RxNavigationViewModel>(_ viewModel: ViewModel,
                                                                      targets: [Identifier],
                                                                      timeout: TimeInterval? = routesTimeout,
                                                                      file: StaticString = #filePath,
                                                                      line: UInt = #line,
                                                                      comparer: (Identifier, Identifier) throws -> Bool,
                                                                      starting callback: @escaping (ViewModel) throws -> Void) rethrows  {
    let routes = viewModel.routes
        .compactMap { $0 }
        .replayAll()
    
    _ = routes.connect()
    try callback(viewModel)
    try assertRoute(routes,
                    targets: targets,
                    timeout: timeout,
                    file: file,
                    line: line,
                    comparer: comparer)
}

public func assertRoute<Identifier: Equatable, ViewModel: RxNavigationViewModel>(_ viewModel: ViewModel,
                                                                                 targeting targets: [Identifier],
                                                                                 timeout: TimeInterval? = routesTimeout,
                                                                                 file: StaticString = #filePath,
                                                                                 line: UInt = #line,
                                                                                 starting callback: @escaping (ViewModel) throws -> Void) rethrows {
    try assertRoute(viewModel,
                    targets: targets,
                    timeout: timeout,
                    file: file,
                    line: line,
                    comparer: { $0 == $1 },
                    starting: callback)
}

public func assert(_ route: Route,
                   hierarchy types: [Scene.Type],
                   file: StaticString = #filePath,
                   line: UInt = #line,
                   exploring exploreClosure: @escaping (Scene) -> Scene?) {
    guard let scene = route.createScene() else {
        guard types.isEmpty == false else {
            return
        }
        XCTFail("Created scene is empty. Expected \(types)", file: file, line: line)
        return
    }
    let starting: Scene? = scene
    _ = types.reduce(starting) { scene, current in
        guard let scene = scene else {
            XCTFail("Scene is null. Expected \(current)", file: file, line: line)
            return nil
        }
        guard type(of: scene) == current else {
            XCTFail("Type of \(type(of: scene)) is not the expected \(current)", file: file, line: line)
            return nil
        }
        return exploreClosure(scene)
    }
}

public func assert<RouteType: Route>(_ route: Route,
                                     of routeType: RouteType.Type,
                                     file: StaticString = #filePath,
                                     line: UInt = #line) {
    guard route is RouteType else {
        XCTFail("Route type is wrong. Expected \(routeType), found \(type(of: route))", file: file, line: line)
        return
    }
}

public func assertNoRoute<ViewModel: RxNavigationViewModel>(_ viewModel: ViewModel,
                                                            timeout: TimeInterval? = routesTimeout,
                                                            file: StaticString = #filePath,
                                                            line: UInt = #line,
                                                            starting callback: @escaping (ViewModel) throws -> Void) rethrows {
    let routes = viewModel.routes
        .compactMap { $0 }
        .replayAll()
    
    _ = routes.connect()
    try callback(viewModel)
    assertNoRoute(routes,
                  timeout: timeout,
                  file: file,
                  line: line)
}

public func assertNoRoute<Stream: ObservableType>(_ stream: Stream,
                                                  timeout: TimeInterval? = routesTimeout,
                                                  file _: StaticString = #filePath,
                                                  line _: UInt = #line) where Stream.Element == Route {
    let values = stream
        .toBlocking(timeout: timeout)
        .materialize()
        .values
    guard values.isEmpty else {
        XCTFail("Stream emitted a route, while no route was expected.")
        return
    }
}
