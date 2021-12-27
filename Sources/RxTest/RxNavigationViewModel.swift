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

public func assertRoute<Stream: ObservableType,
                        Identifier: Equatable>(_ stream: Stream,
                                               targeting targets: [Identifier],
                                               timeout: TimeInterval? = routesTimeout,
                                               file: StaticString = #filePath,
                                               line: UInt = #line) where Stream.Element == Route {
    guard let routes = stream
            .toBlocking(timeout: timeout)
            .materialize()
            .values
            as? [MockRoute<Identifier>]
    else {
        XCTFail("Route is not testable", file: file, line: line)
        return
    }
    guard routes.count == targets.count else {
        XCTFail("Expected \(targets.count) routes (\(targets)), but found \(routes.count) routes ((\(routes))")
        return
    }
    XCTAssertEqual(routes.map { $0.identifier }, targets, file: file, line: line)
}

public func assertRoute<Stream: ObservableType, Identifier: Equatable>(_ route: Stream,
                                                                       targeting target: Identifier,
                                                                       timeout: TimeInterval? = routesTimeout,
                                                                       file: StaticString = #filePath,
                                                                       line: UInt = #line) where Stream.Element == Route {
    assertRoute(route,
                    targeting: [target],
                    timeout: timeout,
                    file: file,
                    line: line)
}

public func assertRoute<ViewModel: RxNavigationViewModel, Identifier: Equatable>(_ viewModel: ViewModel,
                                                                                 targeting target: Identifier,
                                                                                 timeout: TimeInterval? = routesTimeout,
                                                                                 file: StaticString = #filePath,
                                                                                 line: UInt = #line,
                                                                                 starting callback: @escaping (ViewModel) -> Void) {
    assertRoute(viewModel,
                    targeting: [target],
                    timeout: timeout,
                    file: file,
                    line: line,
                    starting: callback)
}

public func assertRoute<Identifier: Equatable, ViewModel: RxNavigationViewModel>(_ viewModel: ViewModel,
                                                                                 targeting targets: [Identifier],
                                                                                 timeout: TimeInterval? = routesTimeout,
                                                                                 file: StaticString = #filePath,
                                                                                 line: UInt = #line,
                                                                                 starting callback: @escaping (ViewModel) -> Void) {
    let routes = viewModel.routes
        .compactMap { $0 }
        .replayAll()
    
    _ = routes.connect()
    callback(viewModel)
    assertRoute(routes,
                    targeting: targets,
                    timeout: timeout,
                    file: file,
                    line: line)
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