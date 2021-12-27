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
