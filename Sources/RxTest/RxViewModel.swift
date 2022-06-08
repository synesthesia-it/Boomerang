//
//  File.swift
//  
//
//  Created by Stefano Mondino on 27/12/21.
//
import Foundation
import RxBlocking
import RxSwift
import XCTest
import Boomerang
#if !COCOAPODS_RXBOOMERANG
import RxBoomerang
#endif

public var routesTimeout: TimeInterval = 5.0

@discardableResult
public func assertComponent<ViewModel: Boomerang.ViewModel>(_ component: Boomerang.ViewModel,
                                                            _ type: ViewModel.Type = ViewModel.self,
                                                            file: StaticString = #filePath,
                                                            line: UInt = #line) throws -> ViewModel {
    try XCTUnwrap(component as? ViewModel, "\(component) is not member of type \(type)")
}

public func assert<Element>(_ observable: Observable<Element>,
                            timeout: TimeInterval = 5.0,
                            file: StaticString = #filePath,
                            line: UInt = #line,
                            trigger: @escaping () -> Void,
                            comparing comparer: @escaping (Element) throws -> Void) throws {
    
    let observable = observable.share(replay: 1, scope: .forever)
    observable.subscribe().disposed(by: disposeBag)

    trigger()

    var element: Element?
    do {
        element = try observable
            .toBlocking(timeout: timeout)
            .first()
    } catch {
        XCTFail("No data available in timeout range: \(error)", file: file, line: line)
        return
    }

    guard let element = element else {
        XCTFail("Data is empty", file: file, line: line)
        return
    }

    try comparer(element)
}
