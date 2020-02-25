# Core Concepts

### Factory

A **Factory** is a stateless object encapsulating initialization details of some object by exposing a protocol or superclass return value.
Example: 
```swift
struct ViewControllerFactory {
    func home() -> UIViewController {
        return LoginViewController()
    }
}
```

### Dependency Container

A **Dependency Container** is an object capable of **registering** declarations and functions (bound to some **key**) that can later be **resolved** by some other contexts. 
It's like a dictionary of closures.
Registering closures can be configured so that they are always executed for every resolution (thus creating a new instance of returned object every time), or having a "singleton" behavior.
For "singletons", registered closures can create the object upon first resolution (`.singleton`) or directly upon registration (`.eagerSingleton`).

Example: 
```swift

container.register(for: "someKey") { return "Hello"}

...

let string = container.resolve("someKey") //Hello
```

Dependency containers are powerful but also dangerous, since are likeky to lead to dependency cycles.

Example of dependency cycle (this will lead to a runtime crash): 
```swift
container.register(for: "a") { SomeObject(container.resolve("b") }
container.register(for: "b") { SomeObject(container.resolve("c") }
container.register(for: "c") { SomeObject(container.resolve("a") }
```
