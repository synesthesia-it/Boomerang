//
//  ShowRowController.swift
//  DemoWatch Extension
//
//  Created by Stefano Mondino on 05/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import WatchKit
import Boomerang

class ShowRowController: NSObject, ViewModelCompatible {
    var viewModel: ShowItemViewModel?
    
    func configure(with viewModel: ShowItemViewModel) {
        titleLabel.setText(viewModel.title)
    }
    
    typealias ViewModel = ShowItemViewModel
    
    @IBOutlet var titleLabel: WKInterfaceLabel!

}
