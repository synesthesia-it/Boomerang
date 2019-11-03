//
//  ViewFactory.swift
//  Demo
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import SwiftUI
import Boomerang
import Combine
import CombineBoomerang
enum ViewIdentifier: String, LayoutIdentifier {
    case show
    
    var identifierString: String {
        return self.rawValue
    }
}

class SwiftUIViewFactory {
    func view(from wrapper: IdentifiableViewModel) -> AnyView {
        
        switch wrapper.viewModel {
        case let viewModel as ShowViewModel: return AnyView(ShowListView(viewModel: viewModel))
        default: return AnyView(Text(""))
        }
    }
}
//class MainViewFactory: ViewFactory {
//    func view(from itemIdentifier: LayoutIdentifier) -> UIView? {
//        return nib(from: itemIdentifier)?
//        .instantiate(withOwner: nil, options: nil)
//        .first as? UIView
//    }
//    
//    func nib(from itemIdentifier: LayoutIdentifier) -> UINib? {
//        return UINib(nibName: name(from: itemIdentifier), bundle: nil)
//    }
//    
//    func name(from itemIdentifier: LayoutIdentifier) -> String {
//        let id = itemIdentifier.identifierString
//        
//        return id.prefix(1).uppercased() + id.dropFirst() + "ItemView"
//    }
//}

