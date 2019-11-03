//
//  HeaderItemView.swift
//  Demo
//
//  Created by Stefano Mondino on 03/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
import Boomerang

class HeaderItemView: UIView, WithViewModel {
    @IBOutlet weak var titleLabel: UILabel?

    func configure(with viewModel: ViewModel) {
        guard let viewModel = viewModel as? HeaderViewModel else { return }
        self.titleLabel?.text = viewModel.title
    }
}
