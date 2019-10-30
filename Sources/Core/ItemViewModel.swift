//
//  ItemViewModel.swift
//  Boomerang
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public protocol ItemIdentifier {
    var identifierString: String { get }
}

public protocol ItemViewModel: AnyObject {
    var id: String? { get }
    var itemIdentifier: ItemIdentifier { get }
}
public extension ItemViewModel {
    var id: String? { return nil }
}

public protocol WithItemViewModel: AnyObject {
    func configure(with viewModel: ItemViewModel)
}
