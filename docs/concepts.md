# Concepts

### Prerequisites
- Basic [MVVM](docs/MVVM.md) knowledge
- Basic [RxSwift](docs/rx.md) knowledge


## Introduction

Boomerang main objective is to standardize app's development by creating "screens" (usually represented by ViewControllers) in the same way. We're take iOS development as example, but it's easy to port same concepts to all platforms.

A single screen usually does 2 main things :
- **Presents** a bunch of data to user
- **Handles interactions** on components

Same concept can be applied to a portion of the screen: elements such single cells in TableViews/CollectionViews basically display data and react to user actions.
This is Boomerang's starting point for standardized app development

### Protocols everywhere

Heavy use of protocols is involved. Sometimes (often), empty protocols are used. This was made in order to guarantee future major improvements to the framework with minor changes required to your codebase: for example, `ModelType` protocol conformance is required for all your Model objects, but the protocol itself is empty.
If Boomerang future improvements will require some methods to be implemented in each `ModelType` object, you'll only have to implement methods or variables *inside* your model object(s) without having to change the rest of your architecture. We want to be future-proof as much as possible.

## Components
#### `ViewModelType` and `ViewModelBindable`

With `ViewModelType` conformance, you're telling Boomerang that your object can be used as a ViewModel in your architecture. The protocol requires your object to be a `class` and no other properties or methods.
View models then can be `bind`ed to views that should read data and display them to the user. This is accomplished by implementing the `ViewModelBindable` protocol.
In this case, two variables are required:
- `viewModel` is a `ViewModelType` variable declaration that should strongly hold the view model
- `disposeBag` is a `DisposeBag` that should dispose all the subscriptions to observables created by viewModel binding
- `func bindTo(viewModel:ViewModelType)` handles proper binding to viewModel data. It should be called after `viewDidLoad` for viewControllers and after dequeue for collectionView/tableView cells. For `UIViewController`, the best place for binding is the `Router`.
In this example, we handle binding between `UIViewController` and its viewModel. The view controller should be properly created in a `UIStoryboard`, with class `MainViewController` and an `IBOutlet` to a `UILabel` named `titleLabel`.
`Router.start()` should be called in the `AppDelegate`'s `applicationDidFinishLaunching` method.


```swift
struct Router {
  static func start() {

    let viewController:MainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainViewController")
    viewController.bindTo(viewModel:MainViewModel(), afterLoad:true)
    delegate.window = UIWindow(frame: UIScreen.main.bounds)
    delegate.window?.rootViewController = self.root()    
    delegate.window?.makeKeyAndVisible()
  }
}

final class MainViewModel : ViewModelType {
  var title:String = "This is a test"
}

class MainViewController : UIViewController, ViewModelBindable {
  var viewModel:MainViewModel?
  var disposeBag = DisposeBag()
  @IBOutlet weak var titleLabel:UILabel?

  func bindTo(viewModel:ViewModelType) {
    guard let viewModel = viewModel as? MainViewModel else {
      return
    }
    self.viewModel = viewModel
    self.titleLabel.text = viewModel.title

  }
}

```

#### `ListViewModelType`

#### `ItemViewModelType`

#### `ViewModelTypeSelectable`

#### `Router`



## Why is Boomerang using a hybrid paradigm?

In [Synesthesia](http://www.synesthesia.it "Synesthesia") we used MVVM a lot to develop tons of iOS apps.
It's great and flexible, with great separation between view, business logic and data layer, and when combined to a RX framework (such as ReactiveSwift) it improves decoupling between apps components.
However, with MVVM alone, we struggled everytime we had to follow some kind of "flow": usually we had a ViewModel returning other viewModels to some listening viewController, with some identifier referencing a Storyboard segue.
This quickly became difficult to manage, especially in situations where same "views" needed to be referenced by multiple parts of the app.
VIPER partially resolved this issue by formally introducing a Router object, responsible of "routing" every request of new views to proper ViewController.
VIPER is not designed to work with a RX framework and (like MVP). We felt more intuitive to simply add Router concepts inside our MVVM infrastructure instead of migrating VIPER in Functional Reactive Programming.
