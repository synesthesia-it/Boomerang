//
//  HeaderViewModel.swift
//  TVMaze
//

import Foundation
import Boomerang
import RxSwift
import RxRelay

class HeaderItemViewModel: ViewModel {

    let layoutIdentifier: LayoutIdentifier
    var uniqueIdentifier: UniqueIdentifier = UUID() 
    let header: String

    
    var title: String {
        return header
    }
    
    init(header: String,
         layoutIdentifier: LayoutIdentifier = ItemIdentifier.header) {
         
        self.layoutIdentifier = layoutIdentifier
        
        self.header = header
        
    }
}
