//
//  GameScreenViewController.swift
//  GameOfFifteen_iOS
//
//  Created by Stefano Mondino on 05/12/21.
//

import Foundation
import UIKit
import Boomerang
import RxBoomerang
import RxSwift
import RxCocoa


class DiffableGameScreenViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    private let viewModel: StateGameScreenViewModel
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
            .with(\.translatesAutoresizingMaskIntoConstraints, to: false)
            .with(\.backgroundColor, to: .white)
    }()

    private let viewFactory: CollectionViewCellFactory
    private let disposeBag = DisposeBag()

    private var collectionViewDataSource: CollectionViewDiffableDataSource? {
            didSet {
                self.collectionView.dataSource = collectionViewDataSource
                self.collectionView.reloadData()
            }
        }

    private var collectionViewDelegate: CollectionViewDelegate? {
            didSet {
                self.collectionView.delegate = collectionViewDelegate
                self.collectionView.collectionViewLayout.invalidateLayout()
            }
        }

    init(viewModel: StateGameScreenViewModel,
         viewFactory: CollectionViewCellFactory) {
        self.viewFactory = viewFactory
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Storyboard not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let viewModel = self.viewModel

        self.view.addSubview(collectionView)

        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        let collectionViewDataSource = CollectionViewDiffableDataSource(viewModel: viewModel, collectionView: collectionView,
                                                                factory: viewFactory)

        let sizeCalculator = DynamicSizeCalculator(viewModel: viewModel,
                                                   factory: viewFactory)

        collectionViewDelegate = CollectionViewDelegate(sizeCalculator: sizeCalculator)
                  .withSelect { viewModel.selectItem(at: $0) }
        
//        collectionView.rx
//                       .animated(by: viewModel, dataSource: collectionViewDataSource)
//                       .disposed(by: disposeBag)

        viewModel.title
            .asDriver(onErrorJustReturn: "")
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)

        viewModel.routes
            .asDriver(onErrorDriveWith: .empty())
            .drive(rx.routes())
            .disposed(by: disposeBag)

        let barButton = UIBarButtonItem(title: "Deck", style: .plain, target: nil, action: nil)
        
        self.navigationItem.rightBarButtonItem = barButton
        
        barButton.rx
            .tap
            .bind{viewModel.changeDeck()}
            .disposed(by: disposeBag)
    }
}

