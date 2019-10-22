//
//  ItemViewModel.swift
//  Boomerang
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public protocol ItemIdentifier: CustomStringConvertible {}

public protocol ItemViewModel {
    var itemIdentifier: ItemIdentifier { get set }
}

public protocol WithItemViewModel: AnyObject {
    func configure(with viewModel: ItemViewModel)
}
