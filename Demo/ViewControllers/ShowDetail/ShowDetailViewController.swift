//
//  ShowDetailViewController.swift
//  Boomerang
//
//  Created by Stefano Mondino on 05/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Boomerang

class ShowDetailViewController: UIViewController, ViewModelCompatible, InteractionCompatible, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.load()
    }
    
    func configure(with viewModel: ShowDetailViewModel) {
        collectionView.delegate = self
        collectionView.set(viewModel: viewModel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.boomerang.automaticSizeForItem(at: indexPath, itemsPerLine: 1)
    }
    
}
