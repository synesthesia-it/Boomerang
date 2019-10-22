//
//  ViewControllerFactory.swift
//  Boomerang
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit

#if os(iOS) || os(tvOS)
public typealias Scene = UIViewController
#endif

public protocol ViewControllerFactory {
    func viewController(from itemIdentifier: ItemIdentifier) -> UIViewController?
}
