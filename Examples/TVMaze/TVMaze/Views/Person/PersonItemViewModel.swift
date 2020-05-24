//
//  PersonViewModel.swift
//  TVMaze
//

import Foundation
import Boomerang
import RxSwift
import RxRelay

class PersonItemViewModel: ViewModel, WithEntity {

    let layoutIdentifier: LayoutIdentifier
    var uniqueIdentifier: UniqueIdentifier = UUID() 
    let person: Person
    let image: ObservableImage
    var entity: Entity { person }
    var title: String {
        return person.name
    }
    
    init(person: Person,
         layoutIdentifier: LayoutIdentifier = ItemIdentifier.person) {
         
        self.layoutIdentifier = layoutIdentifier
        
        self.person = person
        
        self.image = person.image?.medium.getImage() ?? .just(Image())
    }
}
