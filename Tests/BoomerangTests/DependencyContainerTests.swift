//
//  File.swift
//  
//
//  Created by Stefano Mondino on 05/12/21.
//

import XCTest
@testable import Boomerang

class DependencyContainerTests: XCTestCase {
    enum Key: String, Hashable {
        case dependencyA
        case dependencyB
    }
    
    class TestObject {
        let content: UUID = .init()
        init() {}
    }
    
    class TestContainer<Key: Hashable>: DependencyContainer {
        let container: Container<Key>
        init(_ container: Container<Key>) {
            self.container = container
        }
    }
    
    func testObjectIdentifierContainer() throws {
        let container = TestContainer(ObjectContainer())
        container.register {
            "test"
        }
        container.register(for: Int.self) {
            1
        }
        XCTAssertEqual(container.resolve(String.self), "test")
        XCTAssertEqual(container[Int.self], 1)
    }
    func testEnumeratedContainer() throws {
        let container = TestContainer(Container<Key>())
        container.register(for: .dependencyA) {
            "test"
        }
        XCTAssertEqual(container.resolve(.dependencyA), "test")
    }

    func testUniqueScopeReturningNewInstances() throws {
        
        let container = TestContainer(Container<Key>())
        
        container.register(for: .dependencyA) {
            TestObject()
        }
        let valueA: TestObject = container[.dependencyA]
        let valueB: TestObject = container[.dependencyA]
        XCTAssertNotEqual(valueA.content, valueB.content)
    }
    func testSingletonScopeReturningSameInstances() throws {
        
        let container = TestContainer(Container<Key>())
        
        container.register(for: .dependencyA, scope: .singleton) {
            TestObject()
        }
        let valueA: TestObject = container[.dependencyA]
        let valueB: TestObject = container[.dependencyA]
        XCTAssertEqual(valueA.content, valueB.content)
    }
    func testEagerSingletonScopeReturningSameInstancesAndImmediatelyInstantiate() throws {
        
        let container = TestContainer(Container<Key>())
        var initialized = false
        container.register(for: .dependencyA, scope: .eagerSingleton) { () -> TestObject in
            initialized = true
            return TestObject()
        }
        XCTAssertTrue(initialized)
        let valueA: TestObject = container[.dependencyA]
        let valueB: TestObject = container[.dependencyA]
        XCTAssertEqual(valueA.content, valueB.content)
    }
    
    func testSingletonScopeReturningDifferentInstancesOnOverride() throws {
        
        let container = TestContainer(Container<Key>())
        
        container.register(for: .dependencyA, scope: .singleton) {
            TestObject()
        }
        let valueA: TestObject = container[.dependencyA]
        container.register(for: .dependencyA, scope: .singleton) {
            TestObject()
        }
        let valueB: TestObject = container[.dependencyA]
        XCTAssertNotEqual(valueA.content, valueB.content)
    }
}
