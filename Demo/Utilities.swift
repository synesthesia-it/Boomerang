//
//  Utilities.swift
//  Demo
//
//  Created by Stefano Mondino on 27/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

extension String {
    func firstCharacterCapitalized() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
}
