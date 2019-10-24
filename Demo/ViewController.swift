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

    var collectionViewDataSource: DefaultCollectionViewDataSource? {
        didSet {
            self.collectionView.dataSource = collectionViewDataSource
            self.collectionView.reloadData()
        }
    }
    
    var collectionViewDelegate: DefaultCollectionViewDelegate? {
        didSet {
            self.collectionView.delegate = collectionViewDelegate
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collectionViewDataSource = DefaultCollectionViewDataSource(viewModel: viewModel,
                                                         factory: DefaultCollectionViewCellFactory())
        
        let collectionViewDelegate = DefaultCollectionViewDelegate(viewModel: viewModel,
                                                     dataSource: collectionViewDataSource,
                                                     onSelect: { indexPath in print(indexPath) })
        
        self.collectionViewDataSource = collectionViewDataSource
        self.collectionViewDelegate = collectionViewDelegate
        
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
    }
    
    func configure(with viewModel: ItemViewModel) {
        guard let viewModel = viewModel as? TestViewModel else { return }
        self.viewModel = viewModel
    }
    
}

