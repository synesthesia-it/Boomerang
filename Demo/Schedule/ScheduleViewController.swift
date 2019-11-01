//
//  ViewController.swift
//  NewArch
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit
import RxBoomerang
import Boomerang
import RxDataSources
import RxSwift

class ScheduleViewController: UIViewController, WithItemViewModel {
    
    typealias ViewModel = ListViewModel & NavigationViewModel & ItemViewModel
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: ViewModel?
    
    var collectionViewDataSource: CollectionViewDataSource? {
        didSet {
            self.collectionView.dataSource = collectionViewDataSource
            self.collectionView.reloadData()
        }
    }
    
    var collectionViewDelegate: CollectionViewDelegate? {
        didSet {
            self.collectionView.delegate = collectionViewDelegate
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    var router: Router = MainRouter()
    var disposeBag = DisposeBag()
    
    func configure(with viewModel: ItemViewModel) {
        guard let viewModel = viewModel as? ViewModel else { return }
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let viewModel = viewModel else { return }
        
        let collectionViewDataSource = CollectionViewDataSource(viewModel: viewModel,
                                                                factory: MainCollectionViewCellFactory())
        
        let collectionViewDelegate = CollectionViewDelegate(viewModel: viewModel, dataSource: collectionViewDataSource)
            .withItemsPerLine(itemsPerLine: 3)
            .withSelect { viewModel.selectItem(at: $0) }
        //If viewModel is compatible with RxSwift, use RxDataSources with animations
        //Else, use the "classic way" and reload data
        if let viewModel = viewModel as? RxListViewModel {
            collectionView.rx
                .animated(by: viewModel, dataSource: collectionViewDataSource)
                .disposed(by: disposeBag)
        } else {
            self.collectionViewDataSource = collectionViewDataSource
            viewModel.onUpdate = { [weak self] in self?.collectionView.reloadData() }
        }
        
        self.collectionViewDelegate = collectionViewDelegate
        
        viewModel.onNavigation = { [weak self] in
            self?.router.execute($0, from: self)
        }
        
    }
    
}
