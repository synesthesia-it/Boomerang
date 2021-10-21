//
//  BoomerangTests.swift
//  BoomerangTests
//
//  Created by Stefano Mondino on 20/05/2020.
//  Copyright © 2020 Synesthesia. All rights reserved.
//

import XCTest
@testable import Boomerang

extension String: LayoutIdentifier {
    public var identifierString: String { self }
}

class TestItemViewModel: ViewModel {
    var uniqueIdentifier: UniqueIdentifier = UUID()
    var layoutIdentifier: LayoutIdentifier = UUID().stringValue
    let string: String
    init(_ string: String) {
        self.string = string
    }
}

class TestListViewModel: ListViewModel {
    var sections: [Section]
    var onUpdate: () -> Void = {}

    func reload() { }

    func selectItem(at indexPath: IndexPath) {}

    var uniqueIdentifier: UniqueIdentifier = UUID()
    var layoutIdentifier: LayoutIdentifier = UUID().stringValue

    init(sections: [Section]) {
        self.sections = sections
    }
}

class ListViewModelTests: XCTestCase {
    var viewModel: TestListViewModel!
    override func setUpWithError() throws {
        let models = [["A", "B", "C"], ["D", "E", "F"], ["G"]]
        let sections = models.map { Section(items: $0.map(TestItemViewModel.init), info: ["test": "value"])}
        viewModel = TestListViewModel(sections: sections)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIndexOutOfBoundsDoesNotCrash() throws {

        viewModel.deleteSection(at: 100)
        XCTAssert(viewModel.sections.count == 3)
        viewModel.deleteSection(at: -1)
        XCTAssert(viewModel.sections.count == 3)
        viewModel.deleteItem(at: IndexPath(item: 100, section: 0))
        XCTAssert(viewModel.sections.first?.items.count == 3)
        viewModel.deleteItem(at: IndexPath(item: -100, section: 0))
        XCTAssert(viewModel.sections.first?.items.count == 3)
    }
    
    func testInfoInSectionIsProperlyRetained() throws {
        let info = viewModel.sections.first?.info([String: String].self)
        XCTAssert(info != nil)
        XCTAssert(info?["test"] == "value")
    }
    
    func testItemInsertionsAreProperlyHandled() throws {
        viewModel.deleteItem(at: IndexPath(item: 0, section: 0))
        XCTAssert(viewModel.sections.first?.items.count == 2)
        XCTAssert((viewModel.sections.first?.items.first as? TestItemViewModel)?.string == "B")
        viewModel.deleteSection(at: 0)
        XCTAssert(viewModel.sections.count == 2)
        XCTAssert((viewModel.sections.first?.items.first as? TestItemViewModel)?.string == "D")
        viewModel.moveItem(at: IndexPath(item: 0, section: 0), to: IndexPath(item: 1, section: 0))
        XCTAssert((viewModel.sections.first?.items.first as? TestItemViewModel)?.string == "E")
        XCTAssert((viewModel.sections.first?.items.dropFirst().first as? TestItemViewModel)?.string == "D")
        viewModel.moveItem(at: IndexPath(item: 0, section: 0), to: IndexPath(item: 1, section: 1))
        XCTAssert((viewModel.sections.last?.items.dropFirst().first as? TestItemViewModel)?.string == "E")

        viewModel.moveSection(at: 0, to: 1)
        XCTAssert((viewModel.sections.first?.items.first as? TestItemViewModel)?.string == "G")
        XCTAssert((viewModel.sections.last?.items.first as? TestItemViewModel)?.string == "D")

        let newItem = TestItemViewModel("1")
        viewModel.insertItem(newItem, at: IndexPath(item: 0, section: 0))
        XCTAssert(viewModel.sections.first?.items.count == 3)
        XCTAssert((viewModel.sections.first?.items.first as? TestItemViewModel)?.string == "1")
        XCTAssert((viewModel.sections.first?.items.dropFirst().first as? TestItemViewModel)?.string == "G")

        let otherItems = (2..<4).map { TestItemViewModel("\($0)")}
        viewModel.insertItems(otherItems, at: IndexPath(item: 1, section: 0))
        XCTAssert((viewModel.sections.first?.items.first as? TestItemViewModel)?.string == "1")
        XCTAssert((viewModel.sections.first?.items[1] as? TestItemViewModel)?.string == "2")
        XCTAssert((viewModel.sections.first?.items[2] as? TestItemViewModel)?.string == "3")
        XCTAssert((viewModel.sections.first?.items[3] as? TestItemViewModel)?.string == "G")

        let newSectionItems1 = (6..<8).map { TestItemViewModel("\($0)")}
        let newSection1 = Section(items: newSectionItems1)
        viewModel.insertSection(newSection1, at: -1)
        XCTAssert((viewModel.sections.first?.items.first as? TestItemViewModel)?.string == "6")
        XCTAssert((viewModel.sections.first?.items.last as? TestItemViewModel)?.string == "7")

        let newSectionItems2 = (8..<10).map { TestItemViewModel("\($0)")}
        let newSection2 = Section(items: newSectionItems2)
        viewModel.insertSection(newSection2, at: 100)
        XCTAssert((viewModel.sections.last?.items.first as? TestItemViewModel)?.string == "8")
        XCTAssert((viewModel.sections.last?.items.last as? TestItemViewModel)?.string == "9")

        let newSectionItems3 = (10..<12).map { TestItemViewModel("\($0)")}
        let newSection3 = Section(items: newSectionItems3)
        viewModel.insertSection(newSection3, at: 2)
        XCTAssert((viewModel.sections[2].items.first as? TestItemViewModel)?.string == "10")
        XCTAssert((viewModel.sections[2].items.last as? TestItemViewModel)?.string == "11")

    }

}
