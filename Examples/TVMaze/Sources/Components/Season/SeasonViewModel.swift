//
//  SeasonViewModel.swift
//  TVMaze
//
//  Created by Andrea De vito on 29/10/21.
//


import Foundation
import UIKit
import RxSwift
import RxCocoa
import Boomerang
import Kingfisher

class SeasonViewModel: ViewModel{
    let uniqueIdentifier: UniqueIdentifier
    let layoutIdentifier: LayoutIdentifier
    let name : String
    let image : URL?
    let season : Season
    
    init(season : Season, show : Show){
        self.season = season
        uniqueIdentifier = season.id
        layoutIdentifier = ComponentIdentifier.season
        self.name = "Season: \(season.number) "
        self.image = season.image?.medium ?? show.image?.medium
    }
  
}




