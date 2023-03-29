//
//  File.swift
//  
//
//  Created by Stefano Mondino on 05/12/21.
//

import XCTest
@testable import Boomerang

protocol BaseProtocol {}
protocol ExtendedProtocol: BaseProtocol {}

class DependencyContainerTests: XCTestCase {
    enum Key: String, Hashable {
        case dependencyA
        case dependencyB
    }
    
    class TestObject: CustomStringConvertible, Equatable, ExtendedProtocol {
        static func == (lhs: DependencyContainerTests.TestObject, rhs: DependencyContainerTests.TestObject) -> Bool {
            lhs.content == rhs.content
        }
        
        var description: String { content.stringValue }
        let content: UUID = .init()
        init() {}
    }
    
    struct TestStruct: CustomStringConvertible, Equatable {
        static func == (lhs: DependencyContainerTests.TestStruct, rhs: DependencyContainerTests.TestStruct) -> Bool {
            lhs.content == rhs.content
        }
        
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
        
        @Dependency
        var testCustomStringCopy: CustomStringConvertible
        
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
        container.register(for: \.testCustomStringCopy) { "Test2" }
        XCTAssertEqual(container.testCustomStringCopy.description, "Test2")
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

    func testWeakDependencyOnAnyObject() throws {
        let container = ObjectContainer()
        container.register(for: TestObject.self, scope:.weakSingleton) { TestObject() }
        var object = container.resolve(TestObject.self)
        let previousObjectContent = object?.content
        XCTAssertNotNil(object)
        XCTAssertNotNil(container.resolve(TestObject.self))
        XCTAssertEqual(object, container.resolve(TestObject.self))
        object = nil
        let resolvedAgain = try XCTUnwrap(container.resolve(TestObject.self))
        XCTAssertNotEqual(resolvedAgain.content, previousObjectContent)
        
        container.register(for: String.self, scope: .weakSingleton) { "TEST" }
        XCTAssertEqual(container.resolve(), "TEST")
        container.register(for: Int.self, scope: .weakSingleton) { 1 }
        XCTAssertEqual(container.resolve(), 1)
    }
    func testWeakDependencyOnStructs() throws {
        let container = ObjectContainer()
        container.register(scope:.weakSingleton) { TestStruct() }
        var object = container.resolve(TestStruct.self)
        let previousObjectContent = object?.content
        XCTAssertNotNil(object)
        XCTAssertNotNil(container.resolve(TestStruct.self))
        /// Since there's no concept of "weak" on structs, every resolution will always return a different value as in `unique` scope
        XCTAssertNotEqual(object, container.resolve(TestStruct.self))
        object = nil
        let resolvedAgain = try XCTUnwrap(container.resolve(TestStruct.self))
        XCTAssertNotEqual(resolvedAgain.content, previousObjectContent)
        
        container.register(scope: .weakSingleton) { "TEST" }
        XCTAssertEqual(container.resolve(), "TEST")
        container.register(scope: .weakSingleton) { 1 }
        XCTAssertEqual(container.resolve(), 1)
    }
    
    func testExtensionRegistration() throws {
        let baseObject = TestObject()
        let container = ObjectContainer()
        container.register(for: ExtendedProtocol.self) { baseObject }
        container.register(for: BaseProtocol.self) { container.unsafeResolve(ExtendedProtocol.self) }
        let resolved = try XCTUnwrap(container.resolve(ExtendedProtocol.self))
        XCTAssertEqual(baseObject, resolved as? TestObject)
    }
    
    func testSharedContainerResolvesVariable() throws {
        class Container: SharedDependencyContainer {}
        
        let containerA = Container()
        let containerB = Container()
        
        containerA.register { "This is a test" }
        XCTAssertEqual(containerB.resolve(), "This is a test")
        
    }
    
    func testNonSharedContainerResolvesDifferentVariables() throws {
        class Container: DependencyContainer {
            let container = ObjectContainer()
        }
        
        let containerA = Container()
        let containerB = Container()
        
        containerA.register { "This is a test" }
        XCTAssertNotEqual(containerB.resolve(), "This is a test")
        
    }
}

protocol MyContainer {
    func register<Value> (_ block: @escaping () -> Value)
    func resolve<Value>(_ type: Value.Type) throws -> Value
}
extension MyContainer {
    
//    func register<Value, Value2: Value>(_ value: Value.Type = Value.self,
//                                        extendedBy _: Value2.Type,
//                                        block: @escaping () -> Value) {
//
//        self.register(block)
//        self.register { block() as Value2 }
//    }

//    func register<Value, Value2: Value, Value3: Value>(block @escaping () -> Value) {
//
//        self.register(block)
//        self.register { block() as Value2 }
//        self.register { block() as Value3 }
//    }
//
//    func register<Value, Value2: Value, Value3: Value, Value4: Value>(block @escaping () -> Value) {
//
//        self.register(block)
//        self.register { block() as Value2 }
//        self.register { block() as Value3 }
//        self.register { block() as Value4 }
//    }
}
