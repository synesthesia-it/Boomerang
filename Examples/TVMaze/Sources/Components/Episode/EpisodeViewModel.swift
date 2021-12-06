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

class EpisodeViewModel: ViewModel, WithElementSize{
    var elementSize: ElementSize
    
    let uniqueIdentifier: UniqueIdentifier
    
    let layoutIdentifier: LayoutIdentifier
    let title: String
    let subTitle: String?
    let image : URL
   
    init(episode: Episode){
        uniqueIdentifier = episode.id
        layoutIdentifier = ComponentIdentifier.episode
        self.title = episode.description
        if let date = DateFormatter()
            .with(\.dateFormat, to: "yyyy-MM-dd")
            .date(from: episode.airdate ?? "") {
            self.subTitle = DateFormatter()
                .with(\.dateFormat, to: "EEEE d MMMM yyyy")
                .string(from: date)
        }
        else {
            subTitle = ""
        }
        self.image = episode.image?.medium ?? .init(fileURLWithPath: "")
        self.elementSize = Size.fixed(height: 80)
    }
    
    
  
}



