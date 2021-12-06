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

class ImageVieModel: ViewModel{
    let uniqueIdentifier: UniqueIdentifier
    let layoutIdentifier: LayoutIdentifier
    
    let url : URL
    
    init?(url: URL?, layout: Layout){
        guard let url = url else {return nil}
        uniqueIdentifier = UUID()
        layoutIdentifier = layout
        self.url = url
    }
    
    
  
}
enum Layout : String, LayoutIdentifier {
    var identifierString: String {self.rawValue}
    case image
}



