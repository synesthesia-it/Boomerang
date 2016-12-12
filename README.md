

Boomerang is a Swift 3 framework for applications developed with MVVM pattern and (when possibile) driven by tests.
Its built upon ReactiveSwift and (for Cocoa apps) ReactiveCocoa



[![Build Status](https://travis-ci.org/Boomerang/Boomerang.svg)](https://travis-ci.org/Boomerang/Boomerang)
[![Platform](https://img.shields.io/cocoapods/p/Boomerang.svg?style=flat)](https://github.com/Boomerang/Boomerang)
[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/Boomerang.svg)](https://cocoapods.org/pods/Boomerang)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# ⚠️ Warning ⚠️ 

Boomerang is currently under development. It's being used in our projects but breaking changes can happen until we reach the first release.

## What is it?

Boomerang's main objective is to help developers to quickly build apps in a standard and clean way.
It enforces an architecture based on SOLID principles, 90% inspired by MVVM and 10 by VIPER design paradigms steering away from M(assive)VC.
With a clean architecture in mind it's easier to quickly and harmlessly port an iOS app to macOS/tvOS and vice-versa, without affecting the business logic and the model logic of the entire software. At the end, the differences between platforms in a cross platform software should always be a matter of views.

## Why is Boomerang using a hybrid paradigm?

In [Synesthesia](http://www.synesthesia.it "Synesthesia") we used MVVM a lot to develop tons of iOS apps. 
It's great and flexible, with great separation between view, business logic and data layer, and when combined to a RX framework (such as ReactiveSwift) it improves decoupling between apps components.
However, with MVVM alone, we struggled everytime we had to follow some kind of "flow": usually we had a ViewModel returning other viewModels to some listening viewController, with some identifier referencing a Storyboard segue.
This quickly became difficult to manage, especially in situations where same "views" needed to be referenced by multiple parts of the app.
VIPER partially resolved this issue by formally introducing a Router object, responsible of "routing" every request of new views to proper ViewController.
VIPER is not designed to work with a RX framework and (like MVP). We felt more intuitive to simply add Router concepts inside our MVVM infrastructure instead of migrating VIPER in Functional Reactive Programming.




# Credits

Boomerang is written by [Synesthesia](http://www.synesthesia.it "Synesthesia") team.
