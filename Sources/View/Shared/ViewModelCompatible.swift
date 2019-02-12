//
//  ViewModelCompatible.swift
//  Boomerang
//
//  Created by Stefano Mondino on 20/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public protocol ViewModelCompatibleType: class {
    func unwrapViewModel() -> ViewModelType?
    func set(viewModel: ViewModelType)
}
extension ViewModelCompatibleType {
    public func unwrapViewModel() -> ViewModelType? {
        return nil
    }
}

public protocol ViewModelCompatible: ViewModelCompatibleType {
    associatedtype ViewModel: ViewModelType
    var viewModel: ViewModel? { get set }
    func configure(with viewModel: ViewModel)
}
extension ViewModelCompatible {
    
    public func set(viewModel: ViewModelType) {
        if let viewModel = viewModel as? ViewModel {
            self.viewModel = viewModel
            self.configure(with: viewModel)
        }
    }
    public func unwrapViewModel()-> ViewModelType? {
        return self.viewModel
    }
}
