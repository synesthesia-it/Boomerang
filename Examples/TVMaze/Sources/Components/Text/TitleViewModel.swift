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

class TitleViewModel: ViewModel{
    let uniqueIdentifier: UniqueIdentifier
    
    let layoutIdentifier: LayoutIdentifier
    let text: String
    
    init(text: String, layout: Layout){
        uniqueIdentifier = UUID()
        layoutIdentifier = layout
        self.text = text.stripOutHtml() ?? " "
    }
    
       
    
    enum Layout : String, LayoutIdentifier {
        var identifierString: String {self.rawValue}

        case title
        case subTitle
        case summary
        case detail
    }
  
}



extension String {

    func stripOutHtml() -> String? {
        do {
            guard let data = self.data(using: .unicode) else {
                return nil
            }
            let attributed = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            return attributed.string
        } catch {
            return nil
        }
    }
}
