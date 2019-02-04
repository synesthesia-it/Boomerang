//
//  HeaderItemView.swift
//  Demo
//
//  Created by Stefano Mondino on 04/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

class HeaderItemViewModel: IdentifiableItemViewModelType {
    
    var identifier: Identifier = Identifiers.View.header
    var title: String
    init (title: String) {
        self.title = title
    }
}

class HeaderItemView: UIView, ViewModelCompatible {
    
    @IBOutlet var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    func configure(with viewModel: HeaderItemViewModel) {
        title.text = viewModel.title
    }
    
}
