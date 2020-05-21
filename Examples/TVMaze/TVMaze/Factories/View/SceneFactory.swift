//
//  SceneFactory.swift
//  TVMaze
//
//  Created by Stefano Mondino on 21/05/2020.
//  Copyright © 2020 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import Pax

enum SceneIdentifier: String, LayoutIdentifier {
    case menu
    //MURRAY ENUM PLACEHOLDER
    var identifierString: String { rawValue }
}

protocol SceneFactory {
    func root() -> Scene
    func menu() -> Scene
    //MURRAY DECLARATION PLACEHOLDER
}
