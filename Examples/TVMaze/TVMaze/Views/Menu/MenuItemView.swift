//
//  MenuItemView.swift
//  TVMaze
//
//  Created by Stefano Mondino on 21/05/2020.
//  Copyright © 2020 Synesthesia. All rights reserved.
//

import UIKit
import Boomerang

class MenuItemView: UIView, WithViewModel {
    @IBOutlet weak var titleLabel: UILabel!

    func configure(with viewModel: ViewModel) {
        guard let viewModel = viewModel as? MenuItemViewModel else { return }
        titleLabel.text = viewModel.title
    }
}
