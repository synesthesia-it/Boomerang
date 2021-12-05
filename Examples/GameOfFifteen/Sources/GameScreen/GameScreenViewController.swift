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

protocol GameScreenViewModel: RxListViewModel, RxNavigationViewModel {
    var count: Observable<Int> { get }
    func update(count: Int)
    var title: Observable<String> { get }
}

class GameScreenViewController: UIViewController {

    private let viewModel: GameScreenViewModel
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
            .with(\.translatesAutoresizingMaskIntoConstraints, to: false)
            .with(\.backgroundColor, to: .white)
    }()

    private let viewFactory: CollectionViewCellFactory
    private let disposeBag = DisposeBag()

    private var collectionViewDataSource: CollectionViewDataSource? {
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

    init(viewModel: GameScreenViewModel,
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

        let collectionViewDataSource = CollectionViewDataSource(viewModel: viewModel,
                                                                factory: viewFactory)

        let sizeCalculator = DynamicSizeCalculator(viewModel: viewModel,
                                                   factory: viewFactory)

        collectionViewDelegate = CollectionViewDelegate(sizeCalculator: sizeCalculator)
                  .withSelect { viewModel.selectItem(at: $0) }

        collectionView.rx
                       .animated(by: viewModel, dataSource: collectionViewDataSource)
                       .disposed(by: disposeBag)

        let slider = UISlider()
            .with(\.translatesAutoresizingMaskIntoConstraints, to: false)
        view.addSubview(slider)
        let margins = view.layoutMarginsGuide
        slider.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        slider.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        slider.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true

        slider.value = 3
        slider.minimumValue = 2
        slider.maximumValue = 5
        slider.rx.value
            .map { Int(round($0))}
            .distinctUntilChanged()
            .bind { viewModel.update(count: $0) }
            .disposed(by: disposeBag)

        viewModel.title
            .asDriver(onErrorJustReturn: "")
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)

        viewModel.routes
            .asDriver(onErrorDriveWith: .empty())
            .drive(rx.routes())
            .disposed(by: disposeBag)

    }
}
