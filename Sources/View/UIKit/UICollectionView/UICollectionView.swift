//
//  UICollectionView.swift
//  Boomerang
//
//  Created by Stefano Mondino on 20/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


extension UICollectionView: ViewModelCompatibleType {
    public func set(viewModel: ViewModelType) {
        if let viewModel = viewModel as? ListViewModelType {
            self.boomerang.configure(with: viewModel)
        }
    }
}
extension Boomerang where Base: UICollectionView {
    
    public func configure(with viewModel: ListViewModelType, dataSource: CollectionViewDataSource? = nil) {
        
        let dataSource = dataSource ?? CollectionViewDataSource(viewModel: viewModel)
        base.dataSource = dataSource
        base.boomerang.internalDataSource = dataSource
        
        viewModel.updates
            .asDriver(onErrorJustReturn: .none)
            .drive(base.rx.dataUpdates())
            .disposed(by: base.disposeBag)
    }
    
    public func dragAndDrop() -> Disposable {
        let gesture = UILongPressGestureRecognizer()
        base.addGestureRecognizer(gesture)
        return gesture.rx.event.bind {[weak base] gesture in
            guard let base = base else { return }
            switch gesture.state {
            case .began:
                guard let selectedIndexPath = base.indexPathForItem(at: gesture.location(in: base)) else {
                    break
                }
                base.beginInteractiveMovementForItem(at: selectedIndexPath)
            case .changed:
                base.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view ?? base))
            case .ended:
                base.endInteractiveMovement()
            default:
                base.cancelInteractiveMovement()
            }
        }
    }
}

extension Reactive where Base: UICollectionView {
    func dataUpdates() -> Binder<DataHolderUpdate> {
        return Binder(base) { base, updates in
            switch updates {
            case .reload(let updates) :
                print("Reloading")
                _ = updates()
                base.reloadData()
                
            case .deleteItems(let updates):
                let indexPaths = updates()
                print("Deleting \(indexPaths)")
                base.performBatchUpdates({[weak base] in
                    base?.deleteItems(at: indexPaths)
                    }, completion: { (completed) in
                        return
                })
            case .insertItems(let updates):
                let indexPaths = updates()
                print("Inserting \(indexPaths)")
                base.performBatchUpdates({[weak base] in
                    base?.insertItems(at: indexPaths)
                    }, completion: { (completed) in
                        return
                })
                
            case .move(let updates):
                 _ = updates()
            default: break
            }
        }
    }
}
