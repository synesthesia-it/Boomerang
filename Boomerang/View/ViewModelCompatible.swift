//
//  ViewModelCompatible.swift
//  Boomerang
//
//  Created by Stefano Mondino on 20/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public protocol ViewModelCompatibleType: class {
    func set(viewModel: ViewModelType)
}
public protocol ViewModelCompatible: ViewModelCompatibleType {
    associatedtype ViewModel: ViewModelType
    var viewModel: ViewModel? { get set }
    func configure(with viewModel: ViewModel?)
}
extension ViewModelCompatible {
    public func set(viewModel: ViewModelType) {
        self.viewModel = viewModel as? ViewModel
        self.configure(with: self.viewModel)
    }
}
