![alt text](boomerang.png "Boomerang")

Boomerang is a (Rx)Swift micro-framework used to speed up and standardize MVVM (Model-View-ViewModel) native applications development.

[![Platform](https://img.shields.io/cocoapods/p/Boomerang.svg?style=flat)](https://github.com/Boomerang/Boomerang)
[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/Boomerang.svg)](https://cocoapods.org/pods/Boomerang)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# Overview

Boomerang is a micro-framework that helps any developer with MVVM knowledge to standardize the development of an app (currently iOS and tvOS) through common best-practices and data structures.

It's designed with Swift in mind, `protocol` friendly and tightly bound to `RxSwift` (as "classic" MVVM is meant to be used with a proper DataBinding framework). It provides a `DependencyContainer` generic structure to implement **Dependency Injection** and **Inversion of Control** and defines the concept of `Router` and `Routes` to navigate through the app.

The main idea behind Boomerang is that any "screen" (`Scene`) of the app (usually a `UIViewController`) can be represented by a list of views. Users will first ask to (re)load a set of data to be displayed and later interact with it.

Each `View` can be instantiated with its own `ViewModel` in any context and be individually tested and reused across application's screens.

**Boomerang** focus is on the `View` and `ViewModel` layers of the app. The `Model` layer is left out of scope and can be implemented with any pattern/architecture/best practice, as long as it's able to provide data updates through `Observable`s.

# Boomerang lifecycle
Boomerang clears up all usual boilerplate (e.g: `UICollectionView` dataSource methods) by re-organizing how data is handled:

1. Retrieve informations from the *Model Layer*, exposed with an `Observable` of object(s)
2. Group these informations so that they can be displayed in a list. Each displayable element should have its own data representation.
3. For each data in the list, provide a method to create an `ViewModel` that common components can internally bind to individual views or cells
4. Let **Boomerang** do the complex work of data binding for you and simply enjoy your dynamic list.
5. **Interact** with the list and it's item and let the `ViewModel` handle the complex business logic behind your interaction.
6. Use Boomerang's integrated `Router` to separate the concept of `Route` (the "intention" to navigate somewhere through the app) from the actual implementation (e.g.: use a `UINavigationController` to push a new `Scene`). Router is stateless by design, so it doesn't retain any information about current navigation hierarchy.
7. Use Boomerang's integrated `DependencyContainer` to `register` a context that can be `resolved` somewhere else, when needed, without sharing implementation details.

# Example

The `Demo` target inside the main project is made of three actual sample applications for **iOS**, **tvOS** and **watchOS**.
Those applications share most of the code across targets: 
- `ViewModel`s are the same for each platforms
- `Views` have same *.swift* files on **iOS** and **tvOS**, but different *.xib*.

The app uses [TVMaze](https://www.tvmaze.com/api) APIs to retrieve a schedule of TVShows and display them in a `UICollectionView`

Model layer (API calls) and image download are implemented through simple `NSURLSession` rx observable to keep the project super simple.

# Documentation
- [Getting Started](documentation/getting_started.md)
- [ListViewModel](documentation/listviewmodel.md)
- [Identifiers](documentation/identifiers.md)
- [Interactions](documentation/interactions.md)
- [Router](documentation/router.md)
- [Dependencies](documentation/dependencies.md)

# Requirements

- iOS 10.0+ / Mac OS X 10.12+ / tvOS 10.0+ / watchOS 4.0+
- Xcode 10.0+
- Swift 4.2+
- basic knowledge of RxSwift

# Credits

Boomerang is entirely developed and open-sourced by [Synesthesia](https://www.synesthesia.it "Synesthesia").

# License

Boomerang is MIT licensed.
