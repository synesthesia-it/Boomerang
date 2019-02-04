//
//  SceneViewModelType.swift
//  Boomerang
//
//  Created by Stefano Mondino on 04/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public protocol SceneIdentifier: ReusableListIdentifier {
    func scene<T: Scene>() -> T?
}

protocol SceneViewModelType: IdentifiableViewModelType {
    var sceneIdentifier: SceneIdentifier { get }
}

extension SceneViewModelType {
    var identifier: Identifier { return sceneIdentifier }
}
