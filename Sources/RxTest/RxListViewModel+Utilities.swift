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

private let disposeBag = DisposeBag()

open class MockViewModel<Identifier: Equatable>: ViewModel, Equatable {
    private struct Layout: LayoutIdentifier {
        init(_ identifierString: String) {
            self.identifierString = identifierString
        }

        var identifierString: String
    }

    public let uniqueIdentifier: UniqueIdentifier = UUID()
    public var layoutIdentifier: LayoutIdentifier
    public let identifier: Identifier

    internal convenience init?(optional identifier: Identifier?) {
        guard let identifier = identifier else { return nil }
        self.init(identifier)
    }

    public init(_ identifier: Identifier) {
        self.identifier = identifier
        layoutIdentifier = Layout("layout")
    }

    public static func == (lhs: MockViewModel<Identifier>, rhs: MockViewModel<Identifier>) -> Bool {
        lhs.identifier == rhs.identifier
    }
}

public extension Section {
    init<Identifier: Equatable>(id: UniqueIdentifier = UUID(),
                                items: [Identifier],
                                header: Identifier?,
                                footer: Identifier?,
                                info: Any?) {
        self.init(id: id,
                  items: items.compactMap { MockViewModel($0) },
                  header: MockViewModel(optional: header),
                  footer: MockViewModel(optional: footer),
                  supplementary: nil,
                  info: info)
    }
}

public struct TestSection<Identifier: Equatable> {
    public init(items: [Identifier],
                header: Identifier? = nil,
                footer: Identifier? = nil) {
        self.items = items
        self.header = header
        self.footer = footer
    }

    let items: [Identifier]
    let header: Identifier?
    let footer: Identifier?
}

public enum BoomerangTestError: Error {
    case componentNotMatching
}

@discardableResult
public func assertComponent<ViewModel: Boomerang.ViewModel>(_ component: Boomerang.ViewModel,
                                                            _: ViewModel.Type = ViewModel.self,
                                                            file: StaticString = #filePath,
                                                            line: UInt = #line) throws -> ViewModel {
    guard let viewModel = component as? ViewModel else {
        XCTFail("Component of type \(Swift.type(of: component)) is not matching expected \(ViewModel.self)", file: file, line: line)
        throw BoomerangTestError.componentNotMatching
    }
    return viewModel
}

public func assertSections<Identifier: Equatable>(_ viewModel: RxListViewModel,
                                                  items: [[Identifier]],
                                                  timeout: TimeInterval = 5.0,
                                                  _ message: @escaping @autoclosure () -> String = "",
                                                  file: StaticString = #filePath,
                                                  line: UInt = #line) throws {
    try assertSections(viewModel,
                       timeout: timeout,
                       testSections: items.map { TestSection(items: $0) },
                       message(),
                       file: file,
                       line: line)
}

public func assertSections(_ viewModel: RxListViewModel,
                           timeout _: TimeInterval = 5.0,
                           file: StaticString = #filePath,
                           line: UInt = #line,
                           comparing comparer: @escaping ([Section]) throws -> Void) throws {
    let observable = viewModel.sectionsRelay.skip(1).share(replay: 1, scope: .forever)
    observable.subscribe().disposed(by: disposeBag)
    viewModel.reload()
    var sections: [Section]?
    do {
        sections = try observable
            .toBlocking()
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
                                                  _ message: @escaping @autoclosure () -> String = "",
                                                  file: StaticString = #filePath,
                                                  line: UInt = #line) throws {
    let observable = viewModel.sectionsRelay.skip(1).share(replay: 1, scope: .forever)
    observable.subscribe().disposed(by: disposeBag)
    viewModel.reload()

    try assertSections(viewModel,
                       timeout: timeout,
                       file: file,
                       line: line) { sections in

        guard testSections.count == sections.count else {
            XCTAssertEqual(testSections.count, sections.count, message(), file: file, line: line)
            return
        }
        sections.enumerated().forEach { index, section in
            guard let items = section.items as? [MockViewModel<Identifier>] else {
                XCTFail("Wrong section configuration at index \(index). Contents are:\n\n\(section.items)", file: file, line: line)
                return
            }
            XCTAssertEqual(items.map(\.identifier), testSections[index].items, file: file, line: line)
            if section.header != nil {
                guard let header = section.header as? MockViewModel<Identifier> else {
                    XCTFail("Wrong section configuration at index \(index) for header. Header is:\n\n\(section.header!)", file: file, line: line)
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
                       _ message: @autoclosure () -> String = "",
                       file: StaticString = #filePath,
                       line: UInt = #line) {
    guard let itemSize = viewModel.elementSize(at: indexPath, type: type) else {
        if targetSize != nil {
            XCTFail("No item size found for element at \(indexPath), type: \(type ?? "regular item")", file: file, line: line)
        }
        //        XCTFail("No item size found for element at \(indexPath)")
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
    XCTAssertEqual(result, expected, message(), file: file, line: line)
}
