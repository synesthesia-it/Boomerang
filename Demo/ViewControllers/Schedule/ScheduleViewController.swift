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

class ScheduleViewController: UIViewController, WithViewModel {

    typealias ScheduleViewModel = ListViewModel & NavigationViewModel

    @IBOutlet weak var collectionView: UICollectionView!

    var viewModel: ListViewModel & NavigationViewModel

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
         viewModel: ListViewModel & NavigationViewModel,
         collectionViewCellFactory: CollectionViewCellFactory) {
        self.viewModel = viewModel
        self.collectionViewCellFactory = collectionViewCellFactory
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: ViewModel) {
        guard let viewModel = viewModel as? ScheduleViewModel else { return }
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //        guard let viewModel = viewModel else { return }
        let viewModel = self.viewModel
        let collectionViewDataSource = CollectionViewDataSource(viewModel: viewModel,
                                                                factory: collectionViewCellFactory)
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        let sizeCalculator = DynamicSizeCalculator(viewModel: viewModel,
                                                   factory: collectionViewCellFactory)

//        let sizeCalculator = AutomaticCollectionViewSizeCalculator(viewModel: viewModel,
//                                                                   factory: collectionViewCellFactory,
//                                                                   itemsPerLine: 3)
//            .withItemSpacing { _, _ in 10 }
//            .withInsets { _, _ in return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)}
        
        let collectionViewDelegate = CollectionViewDelegate(sizeCalculator: sizeCalculator)
            .withSelect { viewModel.selectItem(at: $0) }

        // If viewModel is compatible with RxSwift, use RxDataSources with animations
        // Else, use the "classic way" and reload data

        if let viewModel = viewModel as? RxListViewModel {
            collectionView.rx
                .animated(by: viewModel, dataSource: collectionViewDataSource)
                .disposed(by: disposeBag)
        } else {
            self.collectionViewDataSource = collectionViewDataSource
            viewModel.onUpdate = { [weak self] in
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }

        if let viewModel = viewModel as? RxNavigationViewModel {
            viewModel.routes
                .bind(to: self.rx.routes())
                .disposed(by: disposeBag)
//            viewModel.routes
//                .observeOn(MainScheduler.instance)
//                .bind { [weak self] route in
//                    route.execute(from: self)
//            }.disposed(by: disposeBag)
        } else {
            viewModel.onNavigation = { [weak self] route in
                route.execute(from: self)
            }
        }

        self.collectionViewDelegate = collectionViewDelegate

        viewModel.reload()

    }

}
