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

class ShowInfoViewModel: ViewModel{
   
    
    let uniqueIdentifier: UniqueIdentifier
    
    let layoutIdentifier: LayoutIdentifier
    var text: String
    let image : URL!
    
   
    init(show: Show){
        uniqueIdentifier = show.id
        layoutIdentifier = ComponentIdentifier.showInfo
        self.text = [show.genres.joined(separator: ", "),
                     show.language ?? "",
                     show.premiered ?? ""]
            .filter{!$0.isEmpty}
            .joined(separator: "\n")
//        self.relased = show.premiered ?? "prova"
//        self.runTime = "\(String(describing: show.runtime))"
//        self.languages = show.language ?? "prova"
//        self.genres = "(\(show.genres)"
        self.image = show.image?.medium
    }
    
    
  
}



