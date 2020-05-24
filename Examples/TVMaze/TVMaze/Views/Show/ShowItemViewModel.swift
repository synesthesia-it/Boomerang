//
//  ShowViewModel.swift
//  TVMaze
//

import Foundation
import Boomerang
import RxSwift
import RxRelay

class ShowItemViewModel: ViewModel, WithEntity {

    let layoutIdentifier: LayoutIdentifier
    var uniqueIdentifier: UniqueIdentifier = UUID() 
    let show: Show

    let image: ObservableImage
    var entity: Entity { show }
    var title: String {
        return show.name
    }
    
    init(show: Show,
         layoutIdentifier: LayoutIdentifier = ItemIdentifier.show) {
         
        self.layoutIdentifier = layoutIdentifier
        
        self.show = show

        self.image = show.image?.medium.getImage() ?? .just(Image())
    }
}
