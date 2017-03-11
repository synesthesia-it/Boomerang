# MVVM

**Model - View - ViewModel** is a design pattern that aims to separate or hide any logic related to business or platform implementation (business logic or model logic) from its presentation to the final user in a view.
This separation is accomplished by defining 3 distinct layers, each one with its own responsibilities and boundaries.

- The **Model** layer: it should implement complex algorithms and operations, data models representations, network calls, low-level interactions with device's hardware such as GPS, accelerometer, etc. In this layer, raw data is converted into *something a developer can understand and manage*
- The view : it should contain and implement everything visible to your users and manage their interactions with the device (button pressed, screen rotation, etc.). It should never be responsible of data manipulation, business model choices and should not depend on any external *state*
- The view-model: it should bridge the other two layers without letting them know anything about each other. It should handle any business logic based on data coming from the model and transform these values into something ready-to-be-used by the view. In this layer, the output data should be *something that can be understood by the app's final user* (e.g: output strings should be ready to be displayed)

We should think about them as "layers" rather than objects: in each layer there can be as many classes/objects/structs as needed.
One common misunderstanding (unfortunately due to a bad yet very common naming practice) is that inside the Model layer we can have many "models", Swift representation of JSON/XML/Database/Whatever objects.

## MVVM interactions: who knows who?

It's crucial to understand proper relationships between layers, in order to maintain a clean, testable, reusable design.
These are the Rules:
- The **Model** layer is totally independent. He doesn't holds any reference to any view or ViewModel. Each object belonging to the model layer should be platform independent whenever possible.
- The **View-Model** layer holds references to the Model, triggers actions and observes it's changes. It shouldn't have any direct reference to any view and, when possible, it shouldn't be directly tied to a view framework (such as UIKit) in order to be used in multiple platforms. If this is not possible, it's useful to use wrappers, typealiases and/or extensions and hide their implementation in target-specific files.
- The **View** layer holds references to the view-model, triggers actions and observes it's changes. It's the only part that needs to be rewritten in a cross-platform environment.


## What do you get with proper MVVM implementation

- You get independent views you can instantiate whenever you want without ties to current app state
- You get app deep-link almost for free
- It's easier to change business logic : you usually end up editing your code in a single place. Your client/employer will like this :)
- It's easy to port your iOS app to tvOS or macOS: if UIs are similar, you usually just end up recreating a bunch of xibs/storyboards and some platform-related view code
- You can test almost everything
