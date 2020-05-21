//
//  ShowViewModel.swift
//  TVMaze
//

import Foundation
import Boomerang
import RxSwift
import RxRelay

class ShowItemViewModel: ViewModel {

    let layoutIdentifier: LayoutIdentifier
    var uniqueIdentifier: UniqueIdentifier = UUID() 
    let show: Show

    
    var title: String {
        return show.name
    }
    
    init(show: Show,
         layoutIdentifier: LayoutIdentifier = ItemIdentifier.show) {
         
        self.layoutIdentifier = layoutIdentifier
        
        self.show = show
        
    }
}
