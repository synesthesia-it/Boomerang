//
//  Router.swift
//  Boomerang
//
//  Created by Stefano Mondino on 05/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS)
import UIKit
public typealias Scene = UIViewController
#endif

public protocol Route {
    var createScene: () -> Scene? { get }
    func execute(from scene: Scene?)
}

