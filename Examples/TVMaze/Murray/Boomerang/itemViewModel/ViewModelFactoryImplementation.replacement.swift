func {{ name|firstLowercase }}(_ {{name|firstLowercase}}: {{name|firstUppercase}}) -> ViewModel {
        {{name|firstUppercase}}ItemViewModel({{name|firstLowercase}}: {{name|firstLowercase}},
                        layoutIdentifier: ItemIdentifier.{{name|firstLowercase}},
                        styleFactory: container.styleFactory)
    }

    
