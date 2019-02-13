# Router

The Router is a stateless object that handles transitions from a `Scene` to another one, based upon informations included in a `Route`.

There is only one `Router` object per application, and it's internally defined by Boomerang.

`Route`s are defined by developer and created by the `ViewModel`. Usually, a route should reference a *destination* viewModel, plus any other parameter that is meaningful to the transition (e.g.: transition time for that specific case).

A `ViewModelRoute` encapsulates a `SceneViewModelType` viewModel and provides a `destination` computed variable that instantiate underlying `Scene` from viewModel's `SceneIdentifier`

A simple route can be something like

```swift
    struct SimpleRoute: ViewModelRoute {
        let viewModel: CustomViewModel
    }
```

This route is usually handed to a `Scene` by an `InteractionViewModel`. The scene is responsible of calling the main `Router` by passing itself as source context and the route as destination parameters.

```swift
//somewhere inside a UIViewController
    func handle(route: SimpleRoute) {
        Router.execute(route, from: self)
    }
```

If the main `Router` was configured to handle a route of type `SimpleRoute` with a configuration closure, that closure is called and navigation happens.

Routes should be configured during bootstrap phase of the app (right after `application:didFinishLaunching` on **iOS**), with something like

```swift
    static func bootstrap() {
        Router.register(SimpleRoute.self) { route, source in
            guard let destination = route.destination else {
                return
            }
            (destination as? UIViewController & ViewModelCompatibleType)?.loadViewAndSet(viewModel: route.viewModel)
            source?.navigationController?.pushViewController(destination, animated: true)
        }
    }
```

Routes can be different across platforms and can be used to limit or enhance navigation across the app.