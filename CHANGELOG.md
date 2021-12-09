# CHANGELOG
All notable changes to this project will be documented in this file

---

## Unreleased

**Breaking**

- Removed `func elementSize(at indexPath: IndexPath) -> ElementSize?` in ListViewModel.
> "Duality" between this method and `func elementSize(at indexPath: IndexPath, type: String?) -> ElementSize?` has caused some issues in normal usage in projects when overriding. We decided to keep a single method. This breaking change shouldn't have any impact on projects.

**New stuff**
- `WithPropertyAssignment` now works with both classes and structs, and includes a closure method to quickly edit object properties upon creation 
> Example: `UILabel().with { $0.text = "hey!" }`
- Introducing `RxBoomerang` pod, which should be preferred over `Boomerang/RxSwift`. This change should allow developers to quickly switch between SPM and Cocoapods without impact on their existing sources.
> As of today, using `pod Boomerang/RxSwift` in Podfile requires to `import Boomerang` only even for Rx extensions. SPM requires a double import (Boomerang + RxBoomerang). With this change we keep the two approaches in sync.
- Introducing `RxBoomerangTest`, a test framework to use in test targets, helping testing process of RxListViewModels and RxNavigationViewModels
- Support for MacOS and Watchos targets 
> There's no real added value at the moment, as we're missing support for AppKit and WatchKit extensions like we have on UIKit. Support is added to simply allow complex projects to link Boomerang in sub-frameworks.
- Some inline documentation
- ... this changelog :) 

**Fixes**
- LICENSE.md is now properly recognized as MIT by automatic parsers.