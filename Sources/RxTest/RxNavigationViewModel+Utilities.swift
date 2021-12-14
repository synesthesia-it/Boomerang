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

open class MockRoute<Identifier: Equatable>: Route, Equatable {
    public static func == (lhs: MockRoute<Identifier>, rhs: MockRoute<Identifier>) -> Bool {
        lhs.identifier == rhs.identifier
    }

    public let createScene: () -> Scene? = { nil }
    let identifier: Identifier
    public func execute<T>(from _: T?) where T: Scene {}

    public init(_ identifier: Identifier) {
        self.identifier = identifier
    }
}

public func assertRoute<Stream: ObservableType, Identifier: Equatable>(_ stream: Stream,
                                                                       targeting targets: [Identifier],
                                                                       timeout: TimeInterval? = 5,
                                                                       _ message: @autoclosure () -> String = "",
                                                                       file: StaticString = #filePath,
                                                                       line: UInt = #line) throws where Stream.Element == Route {
    guard let route = try stream
        .take(targets.count)
        .toBlocking(timeout: timeout)
        .toArray() as? [MockRoute<Identifier>]
    else {
        XCTFail("Route is not testable", file: file, line: line)
        return
    }
    XCTAssertEqual(route.map { $0.identifier }, targets, message(), file: file, line: line)
}

public func assertRoute<Stream: ObservableType, Identifier: Equatable>(_ route: Stream,
                                                                       targeting target: Identifier,
                                                                       timeout: TimeInterval? = 5,
                                                                       _ message: @autoclosure () -> String = "",
                                                                       file: StaticString = #filePath,
                                                                       line: UInt = #line) throws where Stream.Element == Route {
    try assertRoute(route,
                    targeting: [target],
                    timeout: timeout,
                    message(),
                    file: file,
                    line: line)
}

public func assertRoute<ViewModel: RxNavigationViewModel, Identifier: Equatable>(_ viewModel: ViewModel,
                                                                                 targeting target: Identifier,
                                                                                 timeout: TimeInterval? = 5,
                                                                                 _ message: @autoclosure () -> String = "",
                                                                                 file: StaticString = #filePath,
                                                                                 line: UInt = #line,
                                                                                 starting callback: @escaping (ViewModel) -> Void) throws {
    try assertRoute(viewModel,
                    targeting: [target],
                    timeout: timeout,
                    message(),
                    file: file,
                    line: line,
                    starting: callback)
}

public func assertRoute<Identifier: Equatable, ViewModel: RxNavigationViewModel>(_ viewModel: ViewModel,
                                                                                 targeting targets: [Identifier],
                                                                                 timeout: TimeInterval? = 5,
                                                                                 _ message: @autoclosure () -> String = "",
                                                                                 file: StaticString = #filePath,
                                                                                 line: UInt = #line,
                                                                                 starting callback: @escaping (ViewModel) -> Void) throws {
    let routes = viewModel.routes
        .compactMap { $0 }
        .share(replay: targets.count, scope: .forever)
    _ = routes.subscribe()
    callback(viewModel)
    try assertRoute(routes,
                    targeting: targets,
                    timeout: timeout,
                    message(),
                    file: file,
                    line: line)
}

public func assert(_ route: Route,
                   hierarchy types: [Scene.Type],
                   _: @autoclosure () -> String = "",
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
                                     _: @autoclosure () -> String = "",
                                     file: StaticString = #filePath,
                                     line: UInt = #line) {
    guard route is RouteType else {
        XCTFail("Route type is wrong. Expected \(routeType), found \(type(of: route))", file: file, line: line)
        return
    }
}
