//
//  ViewFactory.swift
//  Boomerang
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit

public protocol ViewFactory {
    func view(from itemIdentifier: ItemIdentifier) -> UIView?
    func name(from itemIdentifier: ItemIdentifier) -> String
}
