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
pod 'Boomerang/RxSwift`
```

## Contributing

This project is managed through [XcodeGen](https://github.com/yonaskolb/XcodeGen)
To quickly setup your environment, checkout the repo and run `make setup`. It will install XcodeGen and create the xcodeproj file

After that, edit the `project.yml` file when needed and run `make` every time you add a new dependency or file to the project.


## Table of contents

- [Introduction to MVVM](documentation/mvvm.md)
- [Core concepts](documentation/concepts.md)
- [UIKit integration](documentation/uikit.md)
- [RxSwift integration](documentation/rxswift.md)
- [Combine integration](documentation/combine.md)
- [Real life example: Binge](https://github.com/stefanomondino/Binge)
