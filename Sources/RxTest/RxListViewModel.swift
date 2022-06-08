//
//  RxListViewModel+Utilities.swift
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

let disposeBag = DisposeBag()



public func assertSections<Identifier: Equatable>(_ viewModel: RxListViewModel,
                                                  items: [[Identifier]],
                                                  timeout: TimeInterval = 5.0,
                                                  file: StaticString = #filePath,
                                                  line: UInt = #line) {
    assertSections(viewModel,
                       timeout: timeout,
                       testSections: items.map { TestSection(items: $0) },
                       file: file,
                       line: line)
}

public func assertSections(_ viewModel: RxListViewModel,
                           timeout: TimeInterval = 5.0,
                           file: StaticString = #filePath,
                           line: UInt = #line,
                           comparing comparer: @escaping ([Section]) throws -> Void) rethrows {
    let observable = viewModel
        .sectionsRelay
        .skip(1)
        .share(replay: 1, scope: .forever)
    
    observable.subscribe().disposed(by: disposeBag)
    viewModel.reload()
    var sections: [Section]?
    do {
        sections = try observable
            .toBlocking(timeout: timeout)
            .first()
    } catch {
        XCTFail("No sections populated in timeout range: \(error)", file: file, line: line)
        return
    }
    guard let sections = sections else {
        XCTFail("Section is empty", file: file, line: line)
        return
    }
    try comparer(sections)
}

public func assertSections<Identifier: Equatable>(_ viewModel: RxListViewModel,
                                                  timeout: TimeInterval = 5.0,
                                                  testSections: [TestSection<Identifier>],
                                                  file: StaticString = #filePath,
                                                  line: UInt = #line) {
    let observable = viewModel
        .sectionsRelay
        .skip(1)
        .replayAll()
    
    observable.connect().disposed(by: disposeBag)
    
    viewModel.reload()

    assertSections(viewModel,
                       timeout: timeout,
                       file: file,
                       line: line) { sections in

        guard testSections.count == sections.count else {
            XCTAssertEqual(testSections.count, sections.count, file: file, line: line)
            return
        }
        
        sections
            .enumerated()
            .forEach { index, section in
            guard let items = section.items as? [MockViewModel<Identifier>] else {
                XCTFail("Wrong section configuration at index \(index). Contents are:\n\n\(section.items)",
                        file: file,
                        line: line)
                return
            }
            XCTAssertEqual(items.map(\.identifier),
                           testSections[index].items,
                           file: file,
                           line: line)
                
            if section.header != nil {
                guard let header = section.header as? MockViewModel<Identifier> else {
                    XCTFail("Wrong section configuration at index \(index) for header. Header is:\n\n\(section.header!)",
                            file: file,
                            line: line)
                    return
                }
                XCTAssertEqual(header.identifier, testSections[index].header, file: file, line: line)
            }
                
            if section.footer != nil {
                guard let footer = section.footer as? MockViewModel<Identifier> else {
                    XCTFail("Wrong section configuration at index \(index) for footer. Footer is:\n\n\(section.footer!)", file: file, line: line)
                    return
                }
                XCTAssertEqual(footer.identifier, testSections[index].footer, file: file, line: line)
            }
        }
    }
}

public func assertSize(_ viewModel: ListViewModel,
                       at indexPath: IndexPath,
                       type: String? = nil,
                       equalTo targetSize: ElementSize?,
                       testContainerSize: CGSize = .init(width: 375, height: 667),
                       file: StaticString = #filePath,
                       line: UInt = #line) {
    guard let itemSize = viewModel.elementSize(at: indexPath, type: type) else {
        if targetSize != nil {
            XCTFail("No item size found for element at \(indexPath), type: \(type ?? "regular item")",
                    file: file,
                    line: line)
        }
        return
    }

    let propertiesClosure: (Int) -> Size.ContainerProperties = { count in
        let elementsInLine = CGFloat(count)
        let sectionProperties = viewModel.sectionProperties(at: indexPath.section)
        let availableWidth = (testContainerSize.width - sectionProperties.insets.left - sectionProperties.insets.right)
        let spacingTotalWidth = (sectionProperties.itemSpacing * max(1, elementsInLine - 1))
        let maximumWidth = (availableWidth - spacingTotalWidth) / elementsInLine
        return Size.ContainerProperties(containerBounds: testContainerSize,
                                        maximumWidth: maximumWidth,
                                        maximumHeight: nil)
    }

    let result = itemSize.size(for: propertiesClosure((itemSize as? GridElementSize)?.itemsPerLine ?? 1))
    let expected = targetSize?.size(for: propertiesClosure((targetSize as? GridElementSize)?.itemsPerLine ?? 1))
    XCTAssertEqual(result, expected, file: file, line: line)
}
