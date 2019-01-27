//
//  APIViewController.swift
//  Demo
//
//  Created by Stefano Mondino on 27/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Boomerang

class APIViewController: UIViewController, ViewModelCompatible, UICollectionViewDelegateFlowLayout {
    
    
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewModel = APIViewModel()
        self.set(viewModel: viewModel)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.load()
    }
    
    func configure(with viewModel: APIViewModel) {
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.boomerang.configure(with: viewModel)
        
        let refreshControl = UIRefreshControl()
        viewModel.isLoadingData
            .asDriver(onErrorJustReturn: false)
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        refreshControl.rx
            .controlEvent(.valueChanged)
            .bind { _ in viewModel.load() }
            .disposed(by: disposeBag)
        
        collectionView.addSubview(refreshControl)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let n = self.traitCollection.horizontalSizeClass == .compact ? 2 : 3
        return collectionView.boomerang.automaticSizeForItem(at: indexPath, itemsPerLine: n)
    }
}
