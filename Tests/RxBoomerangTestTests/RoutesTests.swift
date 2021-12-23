//
//  File.swift
//  
//
//  Created by Stefano Mondino on 21/12/21.
//

import Foundation
@testable import RxBoomerangTest
import Boomerang
import RxBoomerang
import RxSwift
import RxRelay
import XCTest

class RoutesTests: XCTestCase {
    
    enum RouteIdentifier: Equatable {
        case first
        case second
        case third
    }
    class ViewModel: RxNavigationViewModel {
        var routes: PublishRelay<Route> = .init()
        
        var uniqueIdentifier: UniqueIdentifier = UUID()
        var layoutIdentifier: LayoutIdentifier = ""
    }
    
    let viewModel = ViewModel()
    
    func testRoutesAreProperlyHandled() throws {
        RxBoomerangTest.routesTimeout = 0.5
        
        assertRoute(viewModel, targeting: [RouteIdentifier.first]) {
            $0.routes.accept(MockRoute(RouteIdentifier.first))
        }
        assertRoute(viewModel, targeting: [RouteIdentifier.second]) {
            $0.routes.accept(MockRoute(RouteIdentifier.second))
        }

    }
    
    func testFailureWhenViewModelEmitsMoreRoutesThanExpected() throws {
        
        assertRoute(viewModel, targeting: [RouteIdentifier.second, .first]) {
            $0.routes.accept(MockRoute(RouteIdentifier.second))
            $0.routes.accept(MockRoute(RouteIdentifier.first))
        }

        XCTExpectFailure {
            assertRoute(viewModel, targeting: [RouteIdentifier.second, .first]) {
                $0.routes.accept(MockRoute(RouteIdentifier.second))
                $0.routes.accept(MockRoute(RouteIdentifier.first))
                $0.routes.accept(MockRoute(RouteIdentifier.third))
            }
        }
    }
}
