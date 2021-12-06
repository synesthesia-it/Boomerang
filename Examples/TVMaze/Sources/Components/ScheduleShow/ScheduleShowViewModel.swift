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

class ScheduleShowViewModel: ViewModel{
    let uniqueIdentifier: UniqueIdentifier
    let layoutIdentifier: LayoutIdentifier
    let image : URL!
    let show : Show
    
    init(show: Show){
        self.show = show
        uniqueIdentifier = show.id
        layoutIdentifier = ComponentIdentifier.scheduleShow
        self.image = show.image?.medium
    }
}


