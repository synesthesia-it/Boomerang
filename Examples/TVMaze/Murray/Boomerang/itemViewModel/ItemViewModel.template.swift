//
//  {{ name|firstUppercase }}ViewModel.swift
//  {{ target || "App" }}
//

import Foundation
import Boomerang
import Model
import RxSwift
import RxRelay

class {{ name|firstUppercase }}ItemViewModel: ViewModel {

    let layoutIdentifier: LayoutIdentifier
    var uniqueIdentifier: UniqueIdentifier = UUID() 
    let {{ name|firstLowercase }}: {{ name|firstUppercase }}
    let image: ObservableImage
    let styleFactory: StyleFactory
    
    var title: String {
        return {{ name|firstLowercase }}.title
    }
    
    init({{ name|firstLowercase }}: {{ name|firstUppercase }},
         layoutIdentifier: LayoutIdentifier = ViewIdentifier.{{ name|firstLowercase }},
         styleFactory: StyleFactory) {
         
        self.layoutIdentifier = layoutIdentifier
        self.styleFactory = styleFactory
        
        self.{{ name|firstLowercase }} = {{ name|firstLowercase }}
        
        self.image = .just(UIImage())            
    }
}
