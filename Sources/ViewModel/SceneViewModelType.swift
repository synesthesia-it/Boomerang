//
//  SceneViewModelType.swift
//  Boomerang
//
//  Created by Stefano Mondino on 04/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public protocol SceneIdentifier: Identifier {
    func scene<T: Scene>() -> T?
}

public protocol SceneViewModelType: IdentifiableViewModelType {
    var sceneIdentifier: SceneIdentifier { get }
}

public extension SceneViewModelType {
    public var identifier: Identifier { return sceneIdentifier }
}
