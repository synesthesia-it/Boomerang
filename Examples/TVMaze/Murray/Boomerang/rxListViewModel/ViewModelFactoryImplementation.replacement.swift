func {{ name|firstLowercase }}() -> {{name|firstUppercase}}ViewModel {
{{name|firstUppercase}}ViewModel(itemViewModelFactory: container.viewModels.items,
                          useCase: container.useCases.{{ name|firstLowercase}},
                          routeFactory: container.routeFactory)
    }

    
