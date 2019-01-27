//
//  ShowItemView.swift
//  Demo
//
//  Created by Stefano Mondino on 27/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Boomerang

class ShowItemViewModel: IdentifiableItemViewModelType {
    
    var identifier: Identifier = Identifiers.View.show
    var title: String
    var model: ModelType
    init (model: Show) {
        self.model = model
        self.title = model.name
    }
}

class ShowItemView: UIView, ViewModelCompatible {
    
    @IBOutlet var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 4
        layer.masksToBounds = true
    }
    func configure(with viewModel: ShowItemViewModel) {
        title.text = viewModel.title
    }
    
}
