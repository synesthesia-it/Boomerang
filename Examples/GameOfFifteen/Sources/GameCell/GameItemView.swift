//
//  GameItemView.swift
//  GameOfFifteen_iOS
//
//  Created by Stefano Mondino on 05/12/21.
//

import Foundation
import UIKit
import RxSwift
import Boomerang

class GameItemView: UIView, WithViewModel {

    @IBOutlet weak var title: UILabel?
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 4
        layer.borderColor = UIColor.blue.cgColor

        title?.textColor = .blue
    }
    func configure(with viewModel: ViewModel) {
        guard let viewModel = viewModel as? GameItemViewModel else { return }
        title?.text = viewModel.description
        backgroundColor = viewModel.description.isEmpty ? .clear : .init(white: 0.95, alpha: 1)
        layer.borderWidth  = viewModel.description.isEmpty ? 0 : 2
    }
}
