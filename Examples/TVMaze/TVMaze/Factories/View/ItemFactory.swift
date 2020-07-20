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

enum ItemIdentifier: String, LayoutIdentifier {
    case menu

	case show
    case showWithTitle
	case person
	case header
	//MURRAY PLACEHOLDER
    var identifierString: String { rawValue }
}