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

class ShowDetailViewController: UIViewController, WithViewModel {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    let viewModel: ShowDetailViewModel
    func configure(with viewModel: ViewModel) {
        
    }
    private let collectionViewCellFactory: CollectionViewCellFactory
    
    init(nibName: String?,
          bundle: Bundle? = nil,
          viewModel: ShowDetailViewModel,
          collectionViewCellFactory: CollectionViewCellFactory) {
        self.viewModel = viewModel
        self.collectionViewCellFactory = collectionViewCellFactory
        super.init(nibName: nibName, bundle: bundle)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = viewModel.title
    }
    
}
