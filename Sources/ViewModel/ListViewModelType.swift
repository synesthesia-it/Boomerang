//
//  ListViewModelType.swift
//  Boomerang
//
//  Created by Stefano Mondino on 19/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift

public protocol ListViewModelType: ViewModelType {
    var dataHolder: DataHolder { get }
    var isLoadingData: Observable<Bool> { get }
    func convert(model: ModelType, at indexPath: IndexPath, for type: String?) -> IdentifiableViewModelType?
    func identifier(at indexPath: IndexPath, for type: String?) -> Identifier?
    func canMoveItem(at indexPath: IndexPath) -> Bool
}

extension ListViewModelType {
    public var groups: Observable<DataGroup> {
        return dataHolder.groups
    }
    public var updates: Observable<DataHolderUpdate> {
        return dataHolder.updates.asObservable()
    }
    public var isLoadingData: Observable<Bool> {
        return dataHolder.isLoading
    }
    public func mainViewModel(at indexPath: IndexPath) -> IdentifiableViewModelType? {
        guard let item = dataHolder.itemCache.mainItem(at: indexPath) else {
            guard let data = dataHolder[indexPath] else { return nil }
            let viewModel: IdentifiableViewModelType?
            switch data {
            case let itemViewModel as IdentifiableViewModelType: viewModel = itemViewModel
            case let model as ModelType: viewModel = self.convert(model: model, at: indexPath, for: nil)
            default: viewModel = nil
            }
            dataHolder.itemCache.replaceItem(viewModel, at: indexPath)
            return viewModel
        }
        return item
    }
    
    public func supplementaryViewModel(at indexPath: IndexPath, for type: String) -> IdentifiableViewModelType? {
        guard let item = dataHolder.itemCache.supplementaryItem(at: indexPath, for: type) else {
            guard let data = dataHolder.supplementaryItem(at: indexPath, for: type) else { return nil }
            let viewModel: IdentifiableViewModelType?
            switch data {
            case let itemViewModel as IdentifiableViewModelType: viewModel = itemViewModel
            case let model as ModelType: viewModel = self.convert(model: model, at: indexPath, for: type)
            default: viewModel = nil
            }
            dataHolder.itemCache.replaceSupplementaryItem(viewModel, at: indexPath, for: type)
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
    
    public func identifier(at indexPath: IndexPath, for type: String?) -> Identifier? {
        return nil
    }
    
    public func canMoveItem(at indexPath: IndexPath) -> Bool {
        return false
    }
    public func moveItem(from: IndexPath, to: IndexPath) {
        self.dataHolder.moveItem(from: from, to: to, immediate: true)
    }
}

public protocol ListViewModel: ListViewModelType {
    associatedtype DataType
    func group(_ observable: Observable<DataType>) -> Observable<DataGroup>
}
