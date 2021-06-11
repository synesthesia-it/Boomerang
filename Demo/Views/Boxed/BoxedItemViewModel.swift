//
//  BoxedItemView.swift
//  Demo_iOS
//
//  Created by Andrea Altea on 10/06/21.
//

import Foundation
import Boomerang

class BoxedViewModel: ViewModel, WithElementSize {

    var elementSize: ElementSize {
        Size.container(useContentInsets: true)
    }
    
    var uniqueIdentifier: UniqueIdentifier
    
    var layoutIdentifier: LayoutIdentifier
    
    init(identifier: ViewIdentifier = .boxed) {
        self.layoutIdentifier = identifier
        self.uniqueIdentifier = identifier.rawValue
    }
}
