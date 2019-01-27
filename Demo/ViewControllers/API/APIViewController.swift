//
//  APIViewController.swift
//  Demo
//
//  Created by Stefano Mondino on 27/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
import Boomerang

class APIViewController: UIViewController, ViewModelCompatible, UICollectionViewDelegateFlowLayout {
    
    let viewModel = APIViewModel()
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure(with: viewModel)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.load()
    }
    func configure(with viewModel: APIViewModel?) {
        collectionView.delegate = self
        collectionView.boomerang.configure(with: self.viewModel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let n = self.traitCollection.horizontalSizeClass == .compact ? 2 : 3
        return collectionView.boomerang.automaticSizeForItem(at: indexPath, itemsPerLine: n)
    }
}
