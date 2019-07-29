//
//  UIStackView.swift
//  Boomerang
//
//  Created by Stefano Mondino on 02/03/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension UIStackView: ViewModelCompatibleType {
    
    public func set(viewModel: ViewModelType) {
        if let viewModel = viewModel as? ListViewModelType {
            self.boomerang.configure(with: viewModel)
        }
    }
}
extension Boomerang where Base: UIStackView {
    
    public func configure(with viewModel: ListViewModelType) {
        viewModel.updates
            .asDriver(onErrorJustReturn: .none)
            .drive(base.rx.dataUpdates(with: viewModel))
            .disposed(by: base.disposeBag)
    }
}


extension Reactive where Base: UIStackView {
    
    func dataUpdates(with viewModel: ListViewModelType) -> Binder<DataHolderUpdate> {
        return Binder(base) { base, updates in
            
            switch updates {
                
            case .reload(let updates) :
                
                let indices = updates()
                base.arrangedSubviews.forEach { $0.removeFromSuperview() }
                indices.forEach { index in
                    guard let vm = viewModel.mainViewModel(at: index),
                        let view = (vm.identifier as? ViewIdentifier)?.view() else {
                            return
                    }
                    base.addArrangedSubview(view)
                    (view as? ViewModelCompatibleType)?.set(viewModel: vm)
                }
                
                break
                
//            case .deleteItems(let updates):
//                let indexPaths = updates()
//                
//                if #available(iOS 11.0, *) {
//                    base.performBatchUpdates({ [weak base] in
//                        base?.deleteRows(at: indexPaths, with: .none)
//                        }, completion: { completed in
//                            return
//                    })
//                } else {
//                    base.beginUpdates()
//                    base.deleteRows(at: indexPaths, with: .none)
//                    base.endUpdates()
//                }
//                
//                break
//                
//            case .insertItems(let updates):
//                let indexPaths = updates()
//                if #available(iOS 11.0, *) {
//                    base.performBatchUpdates({
//                        base.insertRows(at: indexPaths, with: .none)
//                    }, completion: { completed in
//                        return
//                    })
//                } else {
//                    base.beginUpdates()
//                    base.insertRows(at: indexPaths, with: .none)
//                    base.endUpdates()
//                }
//                
//                break
//                
//            case .move(let updates):
//                
//                _ = updates()
//                break
            default: break
            }
        }
    }
}
