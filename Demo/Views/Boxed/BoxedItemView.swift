//
//  BoxedItemView.swift
//  Demo_iOS
//
//  Created by Andrea Altea on 10/06/21.
//

import UIKit
import Boomerang

class BoxedItemView: UIView, WithViewModel {
    
    func configure(with viewModel: ViewModel) {
        self.backgroundColor = .green
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 5
        layer.borderColor = UIColor.darkGray.cgColor
    }
}
