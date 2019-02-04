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
    
    struct Image: Codable {
        var medium: URL?
        var original: URL?
    }
    
    struct Episode: Codable {
        var name: String
        var show: Show
        enum EpisodeCodingKeys: CodingKey {
            case name
            case show
        }
    }
    
    var name: String
    var image: Image?
}
