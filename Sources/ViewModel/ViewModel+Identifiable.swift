//
//  ViewModel+Identifiable.swift
//  Boomerang
//
//  Created by Stefano Mondino on 06/08/18.
//

import Foundation

public let defaultListIdentifier = "default_list_identifier"

public protocol ListIdentifier {
    var name : String { get }
    var isEmbeddable : Bool { get }
}

extension ListIdentifier {
    public var isEmbeddable : Bool { return false }
}

extension String : ListIdentifier {
    public var name : String {
        return self
    }
}
