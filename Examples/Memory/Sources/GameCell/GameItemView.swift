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
    @IBOutlet weak var image: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 4
        layer.borderColor = UIColor.blue.cgColor

        title?.textColor = .blue
    }
    

    
    func configure(with viewModel: ViewModel) {
        guard let viewModel = viewModel as? GameItemViewModel else { return }
        title?.text = viewModel.description
        image?.image = viewModel.image
        backgroundColor =  .init(white: 0.95, alpha: 1)
        layer.borderWidth  = viewModel.description.isEmpty ? 2 : 2
    }
}
