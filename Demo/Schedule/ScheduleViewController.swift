//
//  ViewController.swift
//  NewArch
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit
import Boomerang
class ScheduleViewController: UIViewController, WithItemViewModel {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel:ScheduleViewModel?

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
    
    var router: Router = MainRouter()
    
    func configure(with viewModel: ItemViewModel) {
        guard let viewModel = viewModel as? ScheduleViewModel else { return }
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let viewModel = viewModel else { return }
        
        let collectionViewDataSource = DefaultCollectionViewDataSource(viewModel: viewModel,
                                                         factory: MainCollectionViewCellFactory())
        
        let collectionViewDelegate = DefaultCollectionViewDelegate(viewModel: viewModel,
                                                     dataSource: collectionViewDataSource,
                                                     onSelect: { indexPath in viewModel.selectItem(at: indexPath) })
        
        self.collectionViewDataSource = collectionViewDataSource
        self.collectionViewDelegate = collectionViewDelegate
        
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
                
        viewModel.onNavigation = { [weak self] in
            self?.router.execute($0, from: self)
        }
        
    }
        
}

