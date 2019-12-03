//
//  ViewFactory.swift
//  Boomerang
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit

public typealias Component = UIView & WithViewModel

public protocol ViewFactory {
    func view(from itemIdentifier: LayoutIdentifier) -> UIView?
    func name(from itemIdentifier: LayoutIdentifier) -> String
    func component(from viewModel: ViewModel) -> Component?
}

public extension ViewFactory {
    func component(from viewModel: ViewModel) -> Component? {
        guard let view = self.view(from: viewModel.layoutIdentifier) as? Component else {
            return nil
        }
        view.configure(with: viewModel)
        return view
    }
}
