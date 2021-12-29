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
    
    class TestObject: CustomStringConvertible {
        var description: String { content.stringValue }
        let content: UUID = .init()
        init() {}
    }
    
    class TestContainer<Key: Hashable>: DependencyContainer {
        let container: Container<Key>
        init(_ container: Container<Key>) {
            self.container = container
        }
    }
    
    class CustomContainer: DependencyContainer {
        let container = ObjectContainer()
        
        @Dependency
        var test: Int
        
        @Dependency
        var testCustomString: CustomStringConvertible
        
        var testObject: CustomStringConvertible { self.unsafeResolve(CustomStringConvertible.self) }
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
    
    func testAdvancedContainerWithPropertyWrappers() {
        let container = CustomContainer()
        container.register(for: \.testCustomString) { "Test" }
        XCTAssertEqual(container.testCustomString.description, "Test")
        container.register { 1 }
        XCTAssertEqual(container.test, 1)
        let testObject = TestObject()
        container.register(for: CustomStringConvertible.self) { testObject }
        XCTAssertEqual(container.testObject.description, testObject.description)
        let anotherTestObject = TestObject()
        container.register(for: \.testCustomString) { anotherTestObject }
        XCTAssertEqual(container.testCustomString.description, anotherTestObject.description)
        
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
