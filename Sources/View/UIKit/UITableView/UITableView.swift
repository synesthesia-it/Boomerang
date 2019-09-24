//
//  UITableView.swift
//  Boomerang
//
//  Created by Alberto Bo on 08/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//


import Foundation
import UIKit
import RxSwift
import RxCocoa


extension UITableView: ViewModelCompatibleType {
    
    public func set(viewModel: ViewModelType) {
        if let viewModel = viewModel as? ListViewModelType {
            self.boomerang.configure(with: viewModel)
        }
    }
}
extension Boomerang where Base: UITableView {
    
    public func configure(with viewModel: ListViewModelType, dataSource: TableViewDataSource? = nil, delegate: TableViewDelegate = TableViewDelegate()) {
        
        let dataSource = dataSource ?? TableViewDataSource(viewModel: viewModel)
        base.dataSource = dataSource
        base.delegate = delegate
        base.boomerang.internalDataSource = dataSource
        base.boomerang.internalDelegate = delegate
        
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
                
                break
                
            case .changed:
                
                break
                
                
            case .ended:
                
                break
                
            default: break
                
                //            case .began:
                //                guard let selectedIndexPath = base.indexPathForItem(at: gesture.location(in: base)) else {
                //                    break
                //                }
                //                base.beginInteractiveMovementForItem(at: selectedIndexPath)
                //            case .changed:
                //                base.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view ?? base))
                //            case .ended:
                //                base.endInteractiveMovement()
                //            default:
                //                base.cancelInteractiveMovement()
            }
        }
    }
    
    
}

extension Reactive where Base: UITableView {
    
    func dataUpdates() -> Binder<DataHolderUpdate> {
        return Binder(base) { base, updates in
            
            switch updates {
                
            case .reload(let updates) :
                
                _ = updates()
                base.reloadData()
                break
                
            case .deleteItems(let updates):
                let indexPaths = updates()
                
                if #available(iOS 11.0, *) {
                    base.performBatchUpdates({ [weak base] in
                        base?.deleteRows(at: indexPaths, with: .none)
                        }, completion: { completed in
                            return
                    })
                } else {
                    base.beginUpdates()
                    base.deleteRows(at: indexPaths, with: .none)
                    base.endUpdates()
                }
                
                break
                
            case .deleteSections(let updates):
                let indexPaths = updates()
                let indexSet = IndexSet(indexPaths.compactMap { $0.last })
                if #available(iOS 11.0, *) {
                    base.performBatchUpdates({ [weak base] in
                        base?.deleteSections(indexSet, with: .none)
                        }, completion: { completed in
                            return
                    })
                } else {
                    base.beginUpdates()
                    base.deleteSections(indexSet, with: .none)
                    base.endUpdates()
                }
                
                break
            case .insertItems(let updates):
                let indexPaths = updates()
                if #available(iOS 11.0, *) {
                    base.performBatchUpdates({
                        base.insertRows(at: indexPaths, with: .none)
                    }, completion: { completed in
                        return
                    })
                } else {
                    base.beginUpdates()
                    base.insertRows(at: indexPaths, with: .none)
                    base.endUpdates()
                }
                
                break
            case .insertSections(let updates):
                let indexPaths = updates()
                let indexSet = IndexSet(indexPaths.compactMap { $0.last })
                if #available(iOS 11.0, *) {
                    base.performBatchUpdates({
                        base.insertSections(indexSet, with: .none)
                    }, completion: { completed in
                        return
                    })
                } else {
                    base.beginUpdates()
                    base.insertSections(indexSet, with: .none)
                    base.endUpdates()
                }
                
                break
            case .move(let updates):
                
                _ = updates()
                break
            default: break
            }
        }
    }
}