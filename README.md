# Boomerang

Boomerang is a library for MVVM in Swift applications

Due to the lack of *ViewModel* concepts in UIKit, Boomerang defines a set of scenarios through protocols and shares a common, reusable way to build screens in the app.

On top of that, it provides a set of extensions for common components like `UICollectionView`, `UITableView`, `UIViewController` so that they can become *compatible* with a ViewModel.

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

## Example



## Table of contents

- [Introduction to MVVM](documentation/mvvm.md)
- [Core concepts](documentation/concepts.md)
- [UIKit integration](documentation/uikit.md)
- [RxSwift integration](documentation/rxswift.md)
- [Combine integration](documentation/combine.md)
- [Real life example: Binge](https://github.com/stefanomondino/Binge)
