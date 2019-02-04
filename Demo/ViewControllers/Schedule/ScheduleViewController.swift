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

class ScheduleViewController: UIViewController, ViewModelCompatible, UICollectionViewDelegateFlowLayout {
    
    
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewModel = ScheduleViewModel()
        self.set(viewModel: viewModel)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.load()
    }
    
    func configure(with viewModel: ScheduleViewModel) {
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
        
//        collectionView.boomerang.dragAndDrop().disposed(by: disposeBag)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let n = self.traitCollection.horizontalSizeClass == .compact ? 2 : 3
        return collectionView.boomerang.automaticSizeForItem(at: indexPath, itemsPerLine: n)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return collectionView.boomerang.automaticSizeForItem(at: IndexPath(item: 0, section: 0), type: UICollectionView.elementKindSectionHeader, itemsPerLine: 1)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return collectionView.boomerang.automaticSizeForItem(at: IndexPath(item: 0, section: 0), type: UICollectionView.elementKindSectionHeader, itemsPerLine: 1)
    }
}
