//
//  File.swift
//  
//
//  Created by Stefano Mondino on 09/12/21.
//

import Foundation
import XCTest
@testable import Boomerang

class PropertyAssignmentTests: XCTestCase {
    
    struct SomeValueType: WithPropertyAssignment {
        var value: String = ""
    }
    
    class SomeReferenceType: WithPropertyAssignment {
        var value: String = ""
        init() {}
    }
    
    func testAssignmentOnClasses() throws {
        let object = SomeReferenceType()
        XCTAssertEqual(object.value, "")
        let objectModified = object.with(\.value, to: "changed")
        XCTAssertEqual(objectModified.value, "changed")
        XCTAssertEqual(object.value, "changed")
        XCTAssertTrue(objectModified === object)
        let modifiedAgain = object.with {
            $0.value = "again"
        }
        XCTAssertEqual(object.value, "again")
        XCTAssertEqual(modifiedAgain.value, "again")
        XCTAssertEqual(objectModified.value, "again")
        
    }
    func testAssignmentOnStructs() throws {
        var object = SomeValueType()
        XCTAssertEqual(object.value, "")
        let objectModified = object.with(\.value, to: "changed")
        XCTAssertEqual(objectModified.value, "changed")
        XCTAssertEqual(object.value, "changed")
        let modifiedAgain = object.with {
            $0.value = "again"
        }
        XCTAssertEqual(object.value, "again")
        XCTAssertEqual(modifiedAgain.value, "again")
        XCTAssertEqual(objectModified.value, "changed")
        
    }
}
