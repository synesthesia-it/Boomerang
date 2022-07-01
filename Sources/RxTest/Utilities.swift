//
//  File.swift
//  
//
//  Created by Stefano Mondino on 23/12/21.
//

import Foundation
import RxBlocking
import RxSwift
import XCTest
import Boomerang
#if !COCOAPODS_RXBOOMERANG
import RxBoomerang
#endif

public extension MaterializedSequenceResult {
    var values: [T] {
        switch self {
        case let .completed(elements): return elements
        case let .failed(elements, _): return elements
        }
    }
}

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

open class MockRoute<Identifier>: Route {
    public let createScene: () -> Scene? = { nil }
    let identifier: Identifier
    public func execute<T>(from _: T?) where T: Scene {}
    
    public init(_ identifier: Identifier) {
        self.identifier = identifier
    }
}

extension MockRoute: Equatable where Identifier: Equatable {
    public static func == (lhs: MockRoute<Identifier>, rhs: MockRoute<Identifier>) -> Bool {
        lhs.identifier == rhs.identifier
    }
}
