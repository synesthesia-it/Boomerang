func {{ name|firstLowercase }}(viewModel: {{ name|firstUppercase }}ViewModel) -> Scene {
        return {{ name|firstUppercase }}ViewController(nibName: name(from: viewModel.layoutIdentifier),
                                   	viewModel: viewModel,
                                   	collectionViewCellFactory: collectionViewCellFactory)
    }
    
    
