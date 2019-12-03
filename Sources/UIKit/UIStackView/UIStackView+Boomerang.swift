//
//  UIStackView+Boomerang.swift
//  Demo
//
//  Created by Stefano Mondino on 03/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit

public extension UIStackView {
    func arrangeSections(_ sections:[Section], factory: ViewFactory) {
        self.arrangedSubviews.forEach { self.removeArrangedSubview($0) }
        self.subviews.forEach { $0.removeFromSuperview() }
        sections.flatMap { $0.items }
            .compactMap { factory.component(from: $0) }
            .forEach {
                self.addArrangedSubview($0)
        }
    }
}
