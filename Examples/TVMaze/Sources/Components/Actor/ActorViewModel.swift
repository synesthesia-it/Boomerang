//
//  PersonViewModel.swift
//  TVMaze
//
//  Created by Andrea De vito on 5/11/21.
//


import Foundation
import UIKit
import RxSwift
import RxCocoa
import Boomerang
import Kingfisher

class ActorViewModel: ViewModel{
    let uniqueIdentifier: UniqueIdentifier
    let layoutIdentifier: LayoutIdentifier
    let name : String
    let actorInfo : String
    let image : URL!
    let actor : Actor
    
    init(actor : Actor){
        self.actor = actor
        uniqueIdentifier = actor.id
        layoutIdentifier = ComponentIdentifier.actor
        self.name = actor.name.uppercased()
        self.actorInfo = [actor.birthday ?? "",
                          actor.deathday ?? "is alive",
                          actor.gender ?? ""]
            .filter{!$0.isEmpty}
            .joined(separator: "\n")
        self.image = actor.image?.original
    }
  
}




