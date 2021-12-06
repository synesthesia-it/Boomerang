//
//  EpisodeViewModel.swift
//  TVMaze
//
//  Created by Andrea De vito on 15/10/21.
//


import Foundation
import UIKit
import RxSwift
import RxCocoa
import Boomerang
import Kingfisher

class CastViewModel: ViewModel{
    let uniqueIdentifier: UniqueIdentifier
    let layoutIdentifier: LayoutIdentifier
    let name : String
    let image : URL
    let cast : Cast
    
    init(cast : Cast){
        self.cast = cast
        uniqueIdentifier = cast.person.id
        layoutIdentifier = ComponentIdentifier.cast
        self.name = cast.person.name.uppercased()
        self.image = cast.person.image?.medium ?? URL(fileURLWithPath: "")
       
        
//        URL(string: "https://e7.pngegg.com/pngimages/528/713/png-clipart-woman-question-mark-female-1000-people-presentation.png")
    }
  
}




