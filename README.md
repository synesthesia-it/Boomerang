![alt text](boomerang.png "Boomerang")

Boomerang is a Swift micro-framework for MVVM (Model-View-ViewModel) native applications.

[![Build Status](https://travis-ci.org/Boomerang/Boomerang.svg)](https://travis-ci.org/Boomerang/Boomerang)
[![Platform](https://img.shields.io/cocoapods/p/Boomerang.svg?style=flat)](https://github.com/Boomerang/Boomerang)
[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/Boomerang.svg)](https://cocoapods.org/pods/Boomerang)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# ⚠️ Warning ⚠️

Boomerang is stable from v 4.0, but still on active development. 
Development and releases follow proper semantic versioning.
Documentation is on its way :)

## What is it?

Boomerang's main objective is to help developers to quickly build apps in a standard and clean way.
It enforces an architecture based on SOLID principles, implementing the MVVM pattern with some concepts from VIPER architecture and steering away from M(assive)VC.

With a clean architecture in mind it's easier to quickly and harmlessly port an iOS app to macOS/tvOS and vice-versa, without affecting the business logic and the model logic of the entire software. At the end, the differences between platforms in a cross platform software should always be a matter of views.

## Requirements

- iOS 9.0+ / Mac OS X 10.11+ / tvOS 9.2+ / watchOS 3.0+
- Xcode 9.0+
- Swift 4.0+

# Before we begin

Boomerang is a framework, something that will heavily impact on your codebase and on how you design your app. It's not a drag'n'drop library addressing a single task. It requires some basic understanding of what problem is trying to solve and what tools are involved in the process.

# Documentation

- [MVVM Basics](docs/MVVM.md)
- [Rx Programming Basics](docs/rx.md)
- [Framework concepts](docs/concepts.md)
- [Templates](docs/templates.md)
- [Example app](docs/freesbee.md)

# Credits

Boomerang is entirely written by [Synesthesia](https://www.synesthesia.it "Synesthesia") team.
