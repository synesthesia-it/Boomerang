//
//  ViewModel+Entity.swift
//  TVMaze
//
//  Created by Stefano Mondino on 23/05/2020.
//  Copyright © 2020 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

typealias Entity = Any

protocol WithEntity: ViewModel {
    var entity: Entity { get }
}

extension ViewModel {
    func extractEntity<EntityType>(of: EntityType.Type) -> EntityType? {
        return extractEntity() as? EntityType
    }
    func extractEntity() -> Entity? {
        if !(self is WithEntity) {
            print ("Current view model is not conforming to WithEntity protocol")
        }
        return (self as? WithEntity)?.entity
    }
}
