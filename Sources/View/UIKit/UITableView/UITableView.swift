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
    
    public func configure(with viewModel: ListViewModelType, dataSource: TableViewDataSource? = nil) {
        
        let dataSource = dataSource ?? TableViewDataSource(viewModel: viewModel)
        base.dataSource = dataSource
        base.boomerang.internalDataSource = dataSource
        
        viewModel.updates
            .asDriver(onErrorJustReturn: .none)
            .drive(base.rx.dataUpdates())
            .disposed(by: base.disposeBag)
    }
}

extension Reactive where Base: UITableView {
    
    func dataUpdates() -> Binder<DataHolderUpdate> {
        return Binder(base) { base, updates in
 
            switch updates {

            case .reload(let updates) :
                print("Reloading")
                _ = updates()
                base.reloadData()
                
//
//                            case .deleteItems(let updates):
//                                let indexPaths = updates()
//                                print("Deleting \(indexPaths)")
//                                base.performBatchUpdates({[weak base] in
//
//                                    base?.deleteRows(at: indexPaths, with: UITableView.RowAnimation.none)
//                                }, completion: { (completed) in
//                                        return
//                                })
//
//
                //            case .insertItems(let updates):
                //                let indexPaths = updates()
                //                print("Inserting \(indexPaths)")
                //                base.performBatchUpdates({[weak base] in
                //                    base?.insertItems(at: indexPaths)
                //                    }, completion: { (completed) in
                //                        return
                //                })
                //
                //            case .move(let updates):
                //                _ = updates()
                
            default: break
            }
        }
    }

    
}
