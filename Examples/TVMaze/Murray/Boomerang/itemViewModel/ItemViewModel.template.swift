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
    
    var title: String {
        return {{ name|firstLowercase }}.title
    }
    
    init({{ name|firstLowercase }}: {{ name|firstUppercase }},
         layoutIdentifier: LayoutIdentifier = ItemIdentifier.{{ name|firstLowercase }}) {
         
        self.layoutIdentifier = layoutIdentifier
        
        self.{{ name|firstLowercase }} = {{ name|firstLowercase }}
        
        self.image = .just(UIImage())            
    }
}
