//
//  BoomerangTests.swift
//  BoomerangTests
//
//  Created by Stefano Mondino on 20/05/2020.
//  Copyright © 2020 Synesthesia. All rights reserved.
//

import XCTest
@testable import Boomerang

class TestNavigationViewModel: NavigationViewModel {
    var onNavigation: (Route) -> Void = { _ in }
    
    var uniqueIdentifier: UniqueIdentifier = UUID()
    
    var layoutIdentifier: LayoutIdentifier = "useless"
    
    init() {}
    
    func goSomewhere() {
        onNavigation(FakeRoute())
    }
}

class NavigationViewModelTests: XCTestCase {
    var viewModel: TestNavigationViewModel!
    override func setUpWithError() throws {

        viewModel = TestNavigationViewModel()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testProperNavigationCalled() throws {
        var success: Bool = false
        viewModel.onNavigation = { _ in success = true }
        viewModel.goSomewhere()
        XCTAssertTrue(success)
    }

}
