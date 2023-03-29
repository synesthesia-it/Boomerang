//
//  collectionView.swift
//  TVMaze
//
//  Created by Andrea De vito on 08/10/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Boomerang
import RxBoomerang

class ScheduleViewController: UIViewController {
    var disposeBag = DisposeBag()
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var Search: UIButton!
    let viewModel: ScheduleViewModel
    var dataSource: CollectionViewDataSource? {
        didSet {
            collectionView.dataSource = dataSource
        }
    }
    var delegate: CollectionViewDelegate? {
        didSet {
            collectionView.delegate = delegate
        }
    }

    let components: ComponentFactory

    init(nibName: String,
         bundle: Bundle? = nil,
         viewModel: ScheduleViewModel,
         components: ComponentFactory) {
        self.viewModel = viewModel
        self.components = components
        super.init(nibName: nibName, bundle: bundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let viewModel = self.viewModel
        self.title = viewModel.pageTitle
        let dataSource = CollectionViewDataSource(viewModel: self.viewModel, factory: components)
//        viewModel.onUpdate = { self.collectionView.reloadData()}
        let sizeCalculator = DynamicSizeCalculator(viewModel: viewModel, factory: components)
        delegate = CollectionViewDelegate(sizeCalculator: sizeCalculator).withSelect(select: {  indexPath in
            viewModel.selectItem(at: indexPath)
        })
        collectionView.rx.animated(by: viewModel, dataSource: dataSource)
            .disposed(by: disposeBag)

        let button = UIBarButtonItem(title: "Search", style: .done, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = button
        button.rx.tap
            .bind {viewModel.search()}
            .disposed(by: disposeBag)
        viewModel.routes
            .bind(to: self.rx.routes())
            .disposed(by: disposeBag)
        viewModel.reload()

    }
}

