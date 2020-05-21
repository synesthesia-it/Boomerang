func {{ name|firstLowercase }}() -> {{name|firstUppercase}}ViewModel {
        {{name|firstUppercase}}ViewModel(itemViewModelFactory: container.itemViewModelFactory,
                          useCase: container.model.useCases.{{ name|firstLowercase}},
                          styleFactory: container.styleFactory,
                          routeFactory: container.routeFactory)
    }

    
