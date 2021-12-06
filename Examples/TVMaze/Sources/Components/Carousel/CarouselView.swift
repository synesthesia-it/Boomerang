//
//  ShowDetailsViewController.swift
//  TVMaze
//
//  Created by Andrea De vito on 18/10/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import Boomerang
import RxBoomerang

class CarouselView: UIView, WithViewModel {
    @IBOutlet var collectionView : UICollectionView!
    var disposeBag = DisposeBag()
    var dataSource : CollectionViewDataSource?
    var delegate : CollectionViewDelegate?{
        didSet{
            collectionView.delegate = delegate
        }
    }

    
    func configure(with viewModel: ViewModel) {
        guard let viewModel = viewModel as? CarouselViewModel else {return}
        let dataSource = CollectionViewDataSource(viewModel: viewModel, factory: viewModel.cells)
//        viewModel.onUpdate = { self.collectionView.reloadData()}
        let sizeCalculator = DynamicSizeCalculator(viewModel: viewModel, factory: viewModel.cells)
        collectionView.dataSource = nil
        collectionView.rx.animated(by: viewModel, dataSource: dataSource)
            .disposed(by: disposeBag)
        delegate = CollectionViewDelegate(sizeCalculator: sizeCalculator).withSelect(select: {  indexPath in
            viewModel.selectItem(at: indexPath)
        })
        viewModel.reload()
        
                
    }
}


