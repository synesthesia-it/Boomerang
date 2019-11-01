//
//  ViewController.swift
//  NewArch
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit
import Boomerang
import RxDataSources
import RxSwift

class ScheduleViewController: UIViewController, WithItemViewModel {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel:ScheduleViewModel?

    var collectionViewDataSource: DefaultCollectionViewDataSource? {
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
        guard let viewModel = viewModel as? ScheduleViewModel else { return }
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let viewModel = viewModel else { return }
        
        let collectionViewDataSource = DefaultCollectionViewDataSource(viewModel: viewModel,
                                                         factory: MainCollectionViewCellFactory())
        
        let collectionViewDelegate = CollectionViewDelegate(viewModel: viewModel, dataSource: collectionViewDataSource)
            .withItemsPerLine(itemsPerLine: 3)
            .withSelect { viewModel.selectItem(at: $0) }
                         
        
        
        collectionView.rx
            .animated(by: viewModel, dataSource: collectionViewDataSource)
            .disposed(by: disposeBag)
//        collectionView.rx
//            .reloaded(by: viewModel, dataSource: collectionViewDataSource)
//            .disposed(by: disposeBag)
        
//        self.collectionViewDataSource = collectionViewDataSource
        self.collectionViewDelegate = collectionViewDelegate
        
//        viewModel.onUpdate = { [weak self] in
//            DispatchQueue.main.async {
//                self?.collectionView.reloadData()
//            }
//        }
                
        viewModel.onNavigation = { [weak self] in
            self?.router.execute($0, from: self)
        }
        
    }
        
}

extension Reactive where Base: UICollectionView {
    func reloaded(by viewModel: RxListViewModel, dataSource collectionViewDataSource: DefaultCollectionViewDataSource) -> Disposable {
        
        
        
        let reloadDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<Section, ItemViewModel>>(configureCell:  { (dataSource, cv, indexPath, viewModel) -> UICollectionViewCell in
            return collectionViewDataSource.collectionView(cv, cellForItemAt: indexPath)
        })
            return viewModel.observableSections
                       .asDriver()
                       .map { $0.map { SectionModel(model: $0, items: $0.items) }}
                       .drive(items(dataSource: reloadDataSource))
    }
    func animated(by viewModel: RxListViewModel, dataSource collectionViewDataSource: DefaultCollectionViewDataSource) -> Disposable {
        
        
        
        let reloadDataSource = RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<Section, IdentifiableViewModel>>(configureCell:  { (dataSource, cv, indexPath, viewModel) -> UICollectionViewCell in
            return collectionViewDataSource.collectionView(cv, cellForItemAt: indexPath)
        })
            return viewModel.observableSections
                       .asDriver()
                .map { $0.map { AnimatableSectionModel(model: $0, items: $0.items.map { IdentifiableViewModel(viewModel: $0)}) }}
                       .drive(items(dataSource: reloadDataSource))
    }
}
extension Section: IdentifiableType {
    public var identity: String {
        return self.id
    }
}

struct IdentifiableViewModel: IdentifiableType, Equatable {
    static func == (lhs: IdentifiableViewModel, rhs: IdentifiableViewModel) -> Bool {
        lhs.identity == rhs.identity
    }
    
    var viewModel: ItemViewModel
    var identity: String {
        return viewModel.uniqueIdentifier.stringValue
    }
}
