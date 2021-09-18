//
//  BoomerangTests.swift
//  BoomerangTests
//
//  Created by Stefano Mondino on 20/05/2020.
//  Copyright © 2020 Synesthesia. All rights reserved.
//

import XCTest
@testable import Boomerang

class SectionTests: XCTestCase {
    
    class Item: ViewModel, Equatable {
        static func == (lhs: SectionTests.Item, rhs: SectionTests.Item) -> Bool {
            lhs.title == rhs.title 
        }
        
        let title: String
        let uniqueIdentifier: UniqueIdentifier = UUID()
        let layoutIdentifier: LayoutIdentifier = "test"
        init(_ value: String) {
            self.title = value
        }
    }
    
    let items: [ViewModel] = ["A", "B", "C"].map { Item($0) }
    
    func testValidCreation() throws {
        let section = Section(id: "id", items: items)
        XCTAssertEqual(section.id, "id")
        XCTAssertSectionContains(section, items: items)
    }
    func testValidHeader() throws {
        let header = Item("header")
        let section = Section(items: items, header: header)
        XCTAssertSectionContains(section, items: items)
        XCTAssert(header === section.header)
    }
    func testValidFooter() throws {
        let footer = Item("footer")
        let section = Section(items: items, footer: footer)
        XCTAssertSectionContains(section, items: items)
        XCTAssert(footer === section.footer)
    }
    
    func testValidSupplementary() throws {
        let header = Item("header")
        let footer = Item("footer")
        let custom = Item("custom_1")

        let section = Section(items: items, header: header, footer: footer,supplementary: .init(items: [0: ["custom": custom]]))
        XCTAssertSectionContains(section, items: items)
        XCTAssert(header === section.header)
        XCTAssert(footer === section.footer)
        XCTAssert(section.supplementaryItem(atIndex: 0, forKind: "custom") === custom)
        XCTAssert(section.supplementaryItem(atIndex: 0, forKind: Section.Supplementary.header) === header)
        XCTAssert(section.supplementaryItem(atIndex: 0, forKind: Section.Supplementary.footer) === footer)
    }
    
    func testInsertionOnNonEmptySection() throws {
        var section = Section(items: items)
        let item = Item("new")
        section.insert(item, at: 0)
        XCTAssert(section.items[0] === item)
    }
    
    func testInsertionOnEmptySection() throws {
        var section = Section(items: [])
        let item = Item("new")
        section.insert(item, at: 0)
        XCTAssert(section.items[0] === item)
    }
    
    func testInsertMultipleItems() throws {
        let newItems = ["1", "2", "3"].map { Item($0) }
        var section = Section(items: items)
        section.insert(newItems, at: items.count)
        XCTAssert(section.items.count == items.count + newItems.count)
        XCTAssert(section.items.last === newItems.last)
    }
    
    func testDeleteItem() throws {
        var section = Section(items: items)
        let item = section.remove(at: 0)
        XCTAssert(section.items.count == items.count - 1)
        XCTAssert(section.items[0] === items[1])
        XCTAssert(item === items.first)
    }
    func testDeleteItems() throws {
        var section = Section(items: items)
        let item = section.remove(at: 0)
        XCTAssert(section.items.count == items.count - 1)
        XCTAssert(section.items[0] === items[1])
        XCTAssert(item === items[0])
        let second = section.remove(at: 1)
        XCTAssert(second === items[2])
        XCTAssert(section.items.count == 1)
    }
    func testInsertAtWrongIndex() {
        var section = Section(items: items)
        let item = Item("new")
        section.insert(item, at: items.count + 10)
        XCTAssert(section.items.last === item)
    }
    
    func testSectionInfo() {
        let section = Section(items: [], info: "INFO")
        XCTAssert(section.info(String.self) == "INFO")
    }
}

func XCTAssertSectionContains(_ section: Section, items: [ViewModel]) {
    XCTAssertEqual(section.items.count, items.count)
    zip(section.items, items).forEach { content, expected in
        XCTAssert(content === expected)
    }
}
