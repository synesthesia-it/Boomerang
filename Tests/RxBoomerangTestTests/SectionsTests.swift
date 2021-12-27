//
//  File.swift
//  
//
//  Created by Stefano Mondino on 27/12/21.
//

import Foundation
@testable import RxBoomerangTest
import Boomerang
import RxBoomerang
import RxSwift
import RxRelay
import XCTest

class SectionsTests: XCTestCase {
    
    class ViewModel: RxListViewModel {
        var sectionsRelay: BehaviorRelay<[Section]> = .init(value: [])
        var mocks: Observable<[Section]>
        var disposeBag: DisposeBag = DisposeBag()
        var uniqueIdentifier: UniqueIdentifier = UUID()
        var layoutIdentifier: LayoutIdentifier = "test"
        private var reloadDisposeBag = DisposeBag()
        init(mocks: Observable<[Section]> = .just([])) {
            self.mocks = mocks
        }
        
        func reload() {
            reloadDisposeBag = DisposeBag()
            mocks
                .catchAndReturn([])
                .bind(to: sectionsRelay)
                .disposed(by: reloadDisposeBag)
        }
        
        func selectItem(at indexPath: IndexPath) {}
    }
    
    func testSectionsAreProperlyExplored() throws {
        let items = (0..<10).map { MockViewModel("test \($0)")}
        let viewModel = ViewModel(mocks: .just([Section(items: items)]))
        try assertSections(viewModel) { sections in
            let section = try XCTUnwrap(sections.first)
            XCTAssertEqual(section.items.count, 10)
            try (0..<10).forEach { index in
                let component = try assertComponent(section.items[index], MockViewModel<String>.self)
                XCTAssertEqual(component.identifier, "test \(index)")
            }
        }
    }
    
    func testErrors() throws {
        let viewModel = ViewModel(mocks: .error(BoomerangTestError.componentNotMatching))
        assertSections(viewModel, timeout: 1.0) { sections in
            XCTAssertTrue(sections.isEmpty)
        }
    }
    
}
