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
    
    let router = Router.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collectionViewDataSource = DefaultCollectionViewDataSource(viewModel: viewModel,
                                                         factory: MainCollectionViewCellFactory())
        
        let collectionViewDelegate = DefaultCollectionViewDelegate(viewModel: viewModel,
                                                     dataSource: collectionViewDataSource,
                                                     onSelect: {[weak self] indexPath in self?.viewModel.selectItem(at: indexPath) })
        
        self.collectionViewDataSource = collectionViewDataSource
        self.collectionViewDelegate = collectionViewDelegate
        
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        router.register(NavigationRoute.self) { (route, scene) in
            let text = (route.viewModel as? ShowItemViewModel)?.title ?? "Unknown"
            let alert = UIAlertController(title: "Navigation triggered", message: text, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            scene?.present(alert, animated: true, completion: nil)
        }
        
        viewModel.onNavigation = { [weak self] in
            Router.shared.execute($0, from: self)
        }
        
    }
    
    func configure(with viewModel: ItemViewModel) {
        guard let viewModel = viewModel as? TestViewModel else { return }
        self.viewModel = viewModel
    }
    
}

