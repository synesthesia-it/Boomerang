//
//  ViewController.swift
//  NewArch
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit
import Boomerang
class ViewController: UIViewController, WithItemViewModel {

    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel:TestViewModel!
    
    func configure(with viewModel: ItemViewModel) {
        guard let viewModel = viewModel as? TestViewModel else { return }
        self.viewModel = viewModel
    }
    
    var dataSource: DefaultCollectionViewDataSource? {
        didSet {
            self.collectionView.dataSource = dataSource
            self.collectionView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = DefaultCollectionViewDataSource(viewModel: viewModel, factory: DefaultCollectionViewCellFactory())
    }
    
}

