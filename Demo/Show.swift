//
//  Show.swift
//  Demo
//
//  Created by Stefano Mondino on 27/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

struct Show: ModelType, Codable {
    
    struct Episode: Codable {
        var name: String
        var show: Show
        enum EpisodeCodingKeys: CodingKey {
            case name
            case show
        }
    }
    
    var name: String
    enum ShowCodingKeys: CodingKey {
        case name
    }
}
