//
//  TitleView.swift
//  TVMaze
//
//  Created by Andrea De vito on 18/10/21.
//

import UIKit
import Boomerang

class TitleView: UIView, WithViewModel {
    func configure(with viewModel: ViewModel) {
        guard let viewModel = viewModel as? TitleViewModel else {return}
        text.text = viewModel.text
    }
    @IBOutlet var text: UILabel!
}
