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

class ScheduleViewController: UIViewController, ViewModelCompatible, InteractionCompatible, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.load()
    }
    
    func configure(with viewModel: ScheduleViewModel) {
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        let delegate = CollectionViewDelegate()
            .with(itemsPerLine: 2)
            .with(itemSpacing: {_,_ in 10})
            .with(insets: {_,_ in return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)})
            .with(select: { viewModel.interact(.selectItem($0)) } )
        collectionView.boomerang.configure(with: viewModel, delegate: delegate)
    }
}
