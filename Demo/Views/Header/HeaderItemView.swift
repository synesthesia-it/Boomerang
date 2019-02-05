//
//  HeaderItemView.swift
//  Demo
//
//  Created by Stefano Mondino on 04/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

class HeaderItemView: UIView, ViewModelCompatible {
    
    @IBOutlet var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    func configure(with viewModel: HeaderItemViewModel) {
        title.text = viewModel.title
    }
    
}
