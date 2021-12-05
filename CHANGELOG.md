# CHANGELOG
All notable changes to this project will be documented in this file

---

## Unreleased

**Breaking**

- Removed `func elementSize(at indexPath: IndexPath) -> ElementSize?` in ListViewModel
> "Duality" between this method and `func elementSize(at indexPath: IndexPath, type: String?) -> ElementSize?` has caused some issues in normal usage in projects when overriding. We decided to keep a single method.

**New stuff**
- ... this changelog :) 
- `RxBoomerangTest` is a test framework to use in test target, helping testing process of ListViewModels and NavigationViewModels
- Support for MacOS and Watchos targets 
> There's no real added value at the moment, as we're missing support for AppKit and WatchKit extensions like we have on UIKit. Support is added to simply allow complex projects to link Boomerang in sub-frameworks.
- Some inline documentation

**Fixes**
- LICENSE.md is now properly recognized as MIT by automatic parsers.