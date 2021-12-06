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

class ShowViewModel: ViewModel{
    let uniqueIdentifier: UniqueIdentifier
    let layoutIdentifier: LayoutIdentifier
    let title: String
    let image : URL!
    
    let show : Show
    
    init(show: Show){
        self.show = show
        uniqueIdentifier = show.id
        layoutIdentifier = ComponentIdentifier.show
        self.title = show.name
        self.image = show.image?.medium
    }
}


