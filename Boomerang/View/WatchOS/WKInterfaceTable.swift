//
//  WKInterfaceTable.swift
//  Boomerang-watch
//
//  Created by Stefano Mondino on 05/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import WatchKit

extension WKInterfaceTable: ViewModelCompatibleType {
    public func set(viewModel: ViewModelType) {
        if let viewModel = viewModel as? ListViewModelType {
            self.boomerang.configure(with: viewModel)
        }
    }
}

extension Boomerang where Base: WKInterfaceTable {
    public func configure(with viewModel: ListViewModelType) {
        
        viewModel.updates
            .asDriver(onErrorJustReturn: .none)
            .drive(base.rx.dataUpdates(with: viewModel))
            .disposed(by: base.disposeBag)
    }
}

extension Reactive where Base: WKInterfaceTable {
    func dataUpdates(with viewModel: ListViewModelType) -> Binder<DataHolderUpdate> {
        return Binder(base) { base, updates in
            switch updates {
            case .reload(let group) :
                
                let viewModels = group.indices.compactMap {
                    viewModel.mainViewModel(at: $0)
                }
                if let first = viewModels.first {
                    base.setNumberOfRows(viewModels.count, withRowType: first.identifier.name)
                    viewModels.enumerated().forEach({ (arg) in
                        let (index, vm) = arg
                        (base.rowController(at: index) as? ViewModelCompatibleType)?.set(viewModel: vm)
                    })
                }
                
                
                //            case .deleteItems(let updates):
                //                let indexPaths = updates()
                //                print("Deleting \(indexPaths)")
                //                base.performBatchUpdates({[weak base] in
                //                    base?.deleteItems(at: indexPaths)
                //                    }, completion: { (completed) in
                //                        return
                //                })
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
