# MVVM

**Model-View-ViewModel** is a design pattern where the **view** layer is directly bound to a **view model**, representing its mutable state through time.

The **View Model** acts as a middle layer between the view and the **Model**, which should handle every aspect regarding communication with data providers (REST APIs, Database, etc.). Every time the Model layer has some update, the view model should be notified about that, transform the update into ready-to-be-displayed data for the view and notify it somehow.

The main mechanism involving notification of data updates through time is called **data-binding**.

Boomerang provides very simple data-binding through **closures**. However, best results are obtained with reactive frameworks like Combine or RxSwift.

## Model

The **Model** layer is mainly made of **Entities** representing "real-life" objects, and additional objects that can transform raw data into entities.

Given this very simple JSON raw data object, served by a REST API
```json
{
    "id": 1,
    "name": "Some cool product name",
    "value": 120,
    "currency": "EUR"
}
```

it can be represented by this entity

```swift
struct Product: Codable {
    let id: Int
    let name: String
    let description: String
    let value: Double
    let currency: String
}
```

We can define some kind of service (**data source**) capable of download the raw JSON and decode it into an Entity.
It can be `URLSessionTask`, Alamofire, Moya or whatever kind of REST service available. It can even be anything coming from a local database, Bluetooth connection, user defaults/keychain.

Data Sources are out of the main scope of Boomerang: each app should define it's own way to retrieve its data.

## ViewModel

A **ViewModel** should act as a middleware between what's presented to the app's user (the **View**) and the Model's raw data.

It should be initialized with some Entity and/or being capable to retrieve them by triggering services/data sources.
Eventually, when entity data is available, it should transform it into ready-to-be-displayed data, by exposing properties.

Which properties should be exposed by a ViewModel and how they should transform entity data it's usually a mix of View UI and business logic.

If the app has to show previous `Product` entity, it can define a view model like this:

```swift
class ProductViewModel {
    
    private let product: Product
    let title: String
    let subtitle: String
    
    init(product: Product) {
        self.title = product.name
        self.subtitle = "\(product.value)\(currency)"
    }
}
```

To help in ViewModel definition, Boomerang exposes some protocols defining some basic View model capabilities:

- `ViewModel` for simple definition of a view model
- `ListViewModel` to handle lists of single view models 
- `NavigationViewModel` for view models that can trigger navigations

## View

A **View** is a component capable of rendering components (in UIKit is `UIView`).
From a MVVM perspective, a `UIViewController` is also a view, since it's the component that manage the UIView state. 
In other words, we place inside the **View Layer** any object that can receive and handle a **ViewModel**

A very basic example: 

```
class ProductViewController: UIViewController {
    var viewModel: ProductViewModel?
    
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var subtitleLabel: UILabel?
    
    func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = viewModel?.title
        subtitleLabel.text = viewModel?.subtitle
    }
}
```

While **Model** and **ViewModel** layers can be virtually platform independent (you can share the same view model implementation across SwiftUI, UIKit, WatchKit and AppKit), the view is strictly platform dependent.
Boomerang aims to implement utilities, boilerplate and shortcuts to bind different type of view models to different types of views.

For example, a `ListViewModel` bound to a `UICollectionView` should automatically update the collection view when the underlying list of item view models changes without having to implement a custom datasource, handle differences when sections changes and so on.
