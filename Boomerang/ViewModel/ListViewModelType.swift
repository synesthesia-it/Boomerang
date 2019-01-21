//
//  ListViewModelType.swift
//  Boomerang
//
//  Created by Stefano Mondino on 19/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import Action

public protocol ListViewModelType: ViewModelType {
    var dataHolder: DataHolder { get }
    func convert(model: ModelType, at indexPath: IndexPath, for type: String?) -> ItemViewModelType?
    func identifier(at indexPath: IndexPath, for type: String?) -> Identifier?
}

extension ListViewModelType {
    var groups: Observable<DataGroup> {
        return dataHolder.groups
    }
    var updates: Observable<DataHolderUpdate> {
        return dataHolder.updates.asObservable()
    }
    func mainViewModel(at indexPath: IndexPath) -> ItemViewModelType? {
        guard let item = dataHolder.itemCache.mainItem(at: indexPath) else {
            guard let data = dataHolder[indexPath] else { return nil }
            let viewModel: ItemViewModelType?
            switch data {
            case let itemViewModel as ItemViewModelType: viewModel = itemViewModel
            case let model as ModelType: viewModel = self.convert(model: model, at: indexPath, for: nil)
            default: viewModel = nil
            }
            dataHolder.itemCache.replaceItem(viewModel, at: indexPath)
            return viewModel
        }
        return item
    }
    
    public func load() {
        self.dataHolder.start()
    }
    
    public func cancel() {
        self.dataHolder.cancel()
    }
    
    func identifier(at indexPath: IndexPath, for type: String?) -> Identifier? {
        return nil
    }
}

public protocol ListViewModel: ListViewModelType {
    associatedtype DataType
    func group(_ observable: Observable<DataType>) -> Observable<DataGroup>
}
