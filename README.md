# Boomerang

Boomerang is a library for MVVM in Swift applications

Due to the lack of *ViewModel* concepts in UIKit, Boomerang defines a set of scenarios through protocols and shares a common, reusable way to build screens in the app.

On top of that, it provides a set of extensions for common components like `UICollectionView`, `UITableView`, `UIViewController` so that they can become *compatible* with a ViewModel.

Used with RxSwift (and RxDataSources) bindings (not required, but highly recommended), Boomerang can really improve project workflow and help keeping things simple and light.

## Key Features / TLDR

- Concept of `ViewModel` for all your app.
- `ListViewModel` to handle lists of `ViewModel`s. Each item in the list represents contents for a view (a "cell" in a table/collection view)
- `NavigationViewModel` to handle business logic for navigation through the app 
- `Route` protocol to design and encapsulate how a scene should navigate to another. Write `pushViewController` only once for your app :) 
- Never write datasource and delegate for your collection/table views again!
- Automatic sizing for table view and collection views. Painless.
- TDD-ready: use RxBoomerangTest with your test target to quickly write tests around your code. 


## Installation

Boomerang is available through Cocoapods.

Add this to your Podfile

```ruby
pod 'Boomerang'
```

To use RxSwift integration, use

```ruby
pod 'RxBoomerang`
```
> We used to integrate Rx extensions with `pod Boomerang/RxSwift` 
> This is still available at the moment but differs in how Rx extensions needs to be integrated in your project files: in this old scenario, `import RxBoomerang` is not needed in every file with Boomerang extensions because import is handled by cocoapods; however, we believe that package managers should be interchangeable as much as possible; therefore, we suggest to use the new separated pod as it's more "futureproof".

## Contributing

To integrate new features in the library, you can open the `Package.swift` file and edit the source folder.

## Examples

You can find some integration examples in the `Examples` folder.

## Table of contents (WIP)

- [Introduction to MVVM](documentation/mvvm.md)
- [Core concepts](documentation/concepts.md)
- [UIKit integration](documentation/uikit.md)
- [RxSwift integration](documentation/rxswift.md)
- [Combine integration](documentation/combine.md)
- [Real life example: Binge](https://github.com/stefanomondino/Binge)
