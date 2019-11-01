# Boomerang

Boomerang is a library for MVVM in Swift applications

Due to the lack of **ViewModel* concepts in UIKit, Boomerang defines a set of scenarios through protocols and shares a common, reusable way to build screens in the app.

On top of that, it provides a set of extensions for common components (`UICollectionView`, `UITableView`, `UIViewController`) so that they can become *compatible* with a ViewModel.


## MVVM

**Model-View-ViewModel** is a design pattern where the **view** layer is directly bound to a **view model**, representing its mutable state through time.

The **View Model** acts as a middle layer between the view and the **Model**, which should handle every aspect regarding communication with data providers (REST APIs, Database, etc.). Every time the Model layer has some update, the view model should be notified about that, transform the update into ready-to-be-display data for the view and notify it somehow.

The main mechanism involving notification of data updates through time is called **data-binding**. 

Boomerang provides very simple data-binding through **closures**. However, best results are obtained with reactive frameworks like Combine or RxSwift.


## RxSwift

RxSwift compatibility is provided with a separated framework (**RxBoomerang**)
RxBoomerang uses RxDataSources under the hood to provide data binding to `UICollectionView` and `UITableView`

## Combine

A Combine version is on its way

