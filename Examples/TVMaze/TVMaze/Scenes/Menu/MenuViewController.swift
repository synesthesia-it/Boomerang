//
//  MenuViewController.swift
//  TVMaze
//
//  Created by Stefano Mondino on 21/05/2020.
//  Copyright © 2020 Synesthesia. All rights reserved.
//

import UIKit
import UIKitBoomerang
import Boomerang

class MenuViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView?
    let viewModel: MenuViewModel
    let collectionViewCellFactory: CollectionViewCellFactory

    var collectionViewDataSource: CollectionViewDataSource? {
        didSet {
            self.collectionView?.dataSource = collectionViewDataSource
            self.collectionView?.reloadData()
        }
    }

    var collectionViewDelegate: CollectionViewDelegate? {
        didSet {
            self.collectionView?.delegate = collectionViewDelegate
            self.collectionView?.collectionViewLayout.invalidateLayout()
        }
    }

    init(nibName nibNameOrNil: String?,
         bundle nibBundleOrNil: Bundle? = nil,
         viewModel: MenuViewModel,
         collectionViewCellFactory: CollectionViewCellFactory) {
        self.viewModel = viewModel
        self.collectionViewCellFactory = collectionViewCellFactory
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewModel = self.viewModel
        let collectionViewDataSource = CollectionViewDataSource(viewModel: viewModel,
                                                                factory: collectionViewCellFactory)

        let sizeCalculator = AutomaticCollectionViewSizeCalculator(viewModel: viewModel,
                                                                   factory: collectionViewCellFactory,
                                                                   itemsPerLine: 1)
            .withItemSpacing { _, _ in 10 }
            .withInsets { _, _ in return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)}

        let collectionViewDelegate = CollectionViewDelegate(sizeCalculator: sizeCalculator)
            .withSelect { viewModel.selectItem(at: $0) }
        self.collectionViewDataSource = collectionViewDataSource
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
            }
        }
        self.collectionViewDelegate = collectionViewDelegate
        viewModel.reload()

    }
}
