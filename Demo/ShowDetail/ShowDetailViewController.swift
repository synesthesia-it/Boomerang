//
//  ShowDetailViewController.swift
//  Demo
//
//  Created by Stefano Mondino on 24/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
import Boomerang

class ShowDetailViewController: UIViewController, WithItemViewModel {
    
        @IBOutlet weak var titleLabel: UILabel!
    
    var viewModel: ShowDetailViewModel?
    
    func configure(with viewModel: ItemViewModel) {
        guard let viewModel = viewModel as? ShowDetailViewModel else {
            return
        }
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = viewModel?.title ?? ""
    }

    
}
