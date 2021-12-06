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

class ShowDetailViewController : UIViewController{
    let viewModel : ShowDetailViewModel
    let components : ComponentFactory
    var disposeBag = DisposeBag()
    @IBOutlet var collectionView : UICollectionView!
    var dataSource : CollectionViewDataSource?{
        didSet{
            collectionView.dataSource = dataSource
        }
    }
    var delegate : CollectionViewDelegate?{
        didSet{
            collectionView.delegate = delegate
        }
    }
    
    init(viewModel: ShowDetailViewModel, components : ComponentFactory ){
        self.viewModel = viewModel
        self.components = components
        super.init(nibName: "ShowDetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.pageTitle
        let dataSource = CollectionViewDataSource(viewModel: self.viewModel, factory: components)
        let sizeCalculator = DynamicSizeCalculator(viewModel: viewModel, factory: components)
        delegate = CollectionViewDelegate(sizeCalculator: sizeCalculator).withSelect(select: { [weak self] indexPath in
            self?.viewModel.selectItem(at: indexPath)
        })
        collectionView.rx.animated(by: viewModel, dataSource: dataSource)
            .disposed(by: disposeBag)
        viewModel.routes
            .bind(to:self.rx.routes())
            .disposed(by: disposeBag)
        viewModel.reload()
    }
}


