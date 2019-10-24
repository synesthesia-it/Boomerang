//
//  TestItemView.swift
//  NewArch
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit
import Boomerang

class TestItemView: UIView, WithItemViewModel {
    
    @IBOutlet weak var testLabel: UILabel!
    
    @IBOutlet weak var posterImage: UIImageView!
    
    func configure(with viewModel: ItemViewModel) {
        guard let viewModel = viewModel as? ShowItemViewModel else { return }
        
        self.testLabel.text = viewModel.title
    }
}
