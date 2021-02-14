//
//  ViewController.swift
//  NewArch
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit
import RxBoomerang
import RxDataSources
import RxSwift

class LoremIpsumViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var viewModel: LoremIpsumViewModel

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

    var disposeBag = DisposeBag()
    private let collectionViewCellFactory: CollectionViewCellFactory

    init(nibName nibNameOrNil: String?,
         bundle nibBundleOrNil: Bundle? = nil,
         viewModel: LoremIpsumViewModel,
         collectionViewCellFactory: CollectionViewCellFactory) {
        self.viewModel = viewModel
        self.collectionViewCellFactory = collectionViewCellFactory
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let viewModel = self.viewModel
        let collectionViewDataSource = CollectionViewDataSource(viewModel: viewModel,
                                                                factory: collectionViewCellFactory)

        let sizeCalculator = DynamicSizeCalculator(viewModel: viewModel,
                                                                   factory: collectionViewCellFactory)
        let collectionViewDelegate = CollectionViewDelegate(sizeCalculator: sizeCalculator)
            .withSelect { viewModel.selectItem(at: $0) }

        
            self.collectionViewDataSource = collectionViewDataSource
            viewModel.onUpdate = { [weak self] in
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
        }

        self.collectionViewDelegate = collectionViewDelegate

        viewModel.reload()

    }

}
