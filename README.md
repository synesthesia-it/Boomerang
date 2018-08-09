![alt text](boomerang.png "Boomerang")

Boomerang is a (Rx)Swift micro-framework used to speed up and standardize MVVM (Model-View-ViewModel) native applications development.

[![Platform](https://img.shields.io/cocoapods/p/Boomerang.svg?style=flat)](https://github.com/Boomerang/Boomerang)
[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/Boomerang.svg)](https://cocoapods.org/pods/Boomerang)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# What is it?

Boomerang is a micro-framework that helps any developer with MVVM knowledge to standardize the development of an app (currently iOS and tvOS) through common best-practices and data structures.

It's designed with Swift in mind, `protocol` friendly and tightly bound to `RxSwift` (as MVVM is not so meaningful without a proper DataBinding framework)

The main idea behind Boomerang is that any "screen" of the app (usually, but not always, a ViewController) can be represented by a list of views. Users will first ask to (re)load a set of data to be displayed and later interact with it.

Boomerang clears up all usual boilerplate (e.g: UICollectionView dataSource methods) by re-organizing how data is handled:

- a `UIViewController` with a UICollectionView/UITableView is firstly created and associated (`bind`) to a `ListViewModelType` compliant object: a view model. The list view is also bound to the same view model.

- the ModelLayer usually exposes an `Observable` of data (an array of Boomerang's `ModelType` compliant objects) that gets triggered (`subscribe`d) by ListViewModel
- every model, according to developer's need, is used to create a single `ItemViewModelType` view model for each model.

- each item view model contains a `ListIdentifier` information that is automatically used by the list view to generate proper cells.

- each cell is then bound to the ItemViewModel where actual properties are read and displayed.

# Requirements

- iOS 9.0+ / Mac OS X 10.11+ / tvOS 9.2+ / watchOS 3.0+
- Xcode 9.0+
- Swift 4.0+
- basic knowledge of RxSwift

# Credits

Boomerang is entirely developed and open-sourced by [Synesthesia](https://www.synesthesia.it "Synesthesia").

# License

Boomerang is MIT licensed.
