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
    case shows
    case search
    case show
	//MURRAY ENUM PLACEHOLDER
    var identifierString: String { rawValue }
}

protocol SceneFactory {
    func root() -> Scene
    func menu() -> Scene

    func schedule() -> Scene
    func credits(for person: Person) -> Scene
    func search() -> Scene
    func showDetail(for item: WithShow) -> Scene
    
//MURRAY DECLARATION PLACEHOLDER
}