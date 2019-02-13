# Dependencies

Boomerang incapsulates a really simple *Dependency Container* in order to implement [Inversion of Control](https://en.wikipedia.org/wiki/Inversion_of_control) in applications.

In the most "technical" implementation of a MVVM application in Cocoa world, *Model*, *ViewModel* and *View* can theoretically be separated in frameworks where:

1. `Model.framework` doesn't reference `ViewModel.framework`. Platform-independent
2. `ViewModel.framework` references only `Model.framework`. Platform-independent
3. the "view framework" is actually the `App`, and only references the `ViewModel.framework` - One or more apps per platform (1 iOS, 1 tvOS, ecc..)

The view model is responsible to define all the Identifiers that can be used through the app, but without implementing any of their properties, which can be different across platforms. 

All those view-specific properties can actually be implemented by using a dependency container:

- `App` **registers** inside a container an *implementation* for a custom identifier
- `ViewModel` **resolves** custom identifier from the same container, without actually knowing any implementation detail.

From the `ViewModel` point of view, the `view` property of a `ViewIdentifier` could be either a `UIView` or a `WKInterface`, it will never know/have knowledge of which native framework was used to *generate* that view. 

[Router](router.md) is another efficient example of **Dependency Container**:
- a `Route` behavior is defined in the `App`
- the `Route` is instantiated in the `ViewModel`
- when receiving a `Route`, the Router **resolves** the behavior and executes it.

Dependency Containers are crucial for a clear separation of concerns between architectural components of the app.
 
While they can be difficult to understand at first (or maybe useless for someone), they provide a great degree of configuration and helps to clarify behaviors of applications.


