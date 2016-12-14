![alt text](boomerang.png "Boomerang")

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

## Requirements

- iOS 8.0+ / Mac OS X 10.11+ / tvOS 9.0+ / watchOS 3.0+
- Xcode 8.0+
- Swift 3.0+


# Before we begin

Boomerang is a framework, something that will heavily impact on your codebase and on how you design your app. It's not a drag'n'drop library addressing one single task. It requires some basic understanding of what problem is trying to solve and what tools are involved in the process. 

## MVVM

MVMM is a design pattern involving 3 main actors in an ecosystem that should (not always) allow observation of values and data-binding.
These 3 "actors" are :
- The model layer: it should implement complex algorithms and operations, data models representations, network calls, low-level interactions with device's hardware such as GPS, accelerometer, etc.
- The view : it should contain and implement everything visible to your users and manage their interactions with the device (button pressed, screen rotation, etc.)
- The view-model: it should bridge the other two layers without letting them know anything about each other. It should handle any business logic based on data coming from the model and transform these values into something ready-to-be-used by the view.
We should think about them as "layers" rather than objects: in each layer there can be as many classes/objects/structs as needed.
One common misunderstanding (unfortunately due to a bad yet very common naming practice) is that inside the Model layer we can have many "models", Swift representation of (usually) JSON objects.

### MVVM interactions: who knows who?

It's crucial to understand proper relationships between layers, in order to mantain a clean, testable, reusable design.
These are the Rules:
- The model layer is totally independent. He doesn't holds any reference to any view (=> platform independent) or ViewModel.
- The view-model layer holds references to the model layer, triggers actions and observes it's changes. It shouldn't have any direct reference to any view and, when possibile, it shouldn't be directly tied to a view framework (such as UIKit) in order to be used in multiple plaform. When this is not possible, it's useful to use wrappers and typealiases and hide their implementation in platform-specific files. 
- The view layer holds references to the view-model, triggers actions and observes it's changes. It's the only part that needs to be rewritten in a crossplatform environment.

## ReactiveSwift / ReactiveCocoa 








## Why is Boomerang using a hybrid paradigm?

In [Synesthesia](http://www.synesthesia.it "Synesthesia") we used MVVM a lot to develop tons of iOS apps. 
It's great and flexible, with great separation between view, business logic and data layer, and when combined to a RX framework (such as ReactiveSwift) it improves decoupling between apps components.
However, with MVVM alone, we struggled everytime we had to follow some kind of "flow": usually we had a ViewModel returning other viewModels to some listening viewController, with some identifier referencing a Storyboard segue.
This quickly became difficult to manage, especially in situations where same "views" needed to be referenced by multiple parts of the app.
VIPER partially resolved this issue by formally introducing a Router object, responsible of "routing" every request of new views to proper ViewController.
VIPER is not designed to work with a RX framework and (like MVP). We felt more intuitive to simply add Router concepts inside our MVVM infrastructure instead of migrating VIPER in Functional Reactive Programming.




# Credits

Boomerang is written by [Synesthesia](http://www.synesthesia.it "Synesthesia") team.
