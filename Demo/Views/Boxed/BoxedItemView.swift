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
}
