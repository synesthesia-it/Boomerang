//
//  ViewModelCache.swift
//  Boomerang
//
//  Created by Stefano Mondino on 20/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

private struct ViewModelCacheItem {
    var mainItem: ItemViewModelType?
    var supplementaryItems: [String: ItemViewModelType] = [:]
}

struct ViewModelCache {
    private var cache:[IndexPath: ViewModelCacheItem] = [:]
    internal var isEnabled: Bool = true
    init() { }
    mutating func clear() {
        cache = [:]
    }
    
    func mainItem(at indexPath: IndexPath) -> ItemViewModelType? {
        if !isEnabled { return nil }
        return cache[indexPath]?.mainItem
    }
    
    mutating func replaceItem(_ item: ItemViewModelType?, at indexPath: IndexPath) {
        if !isEnabled { return }
        
        var cacheItem = cache[indexPath] ?? ViewModelCacheItem()
        cacheItem.mainItem = item
        self.cache[indexPath] = cacheItem
//        self.cache = cache
    }
    
    func supplementaryItem(at indexPath: IndexPath, for type: String) -> ItemViewModelType? {
        if !isEnabled { return nil }
        return cache[indexPath]?.supplementaryItems[type]
    }
    
    mutating func replaceSupplementaryItem(_ item: ItemViewModelType?, at indexPath: IndexPath, for type: String) {
        if !isEnabled { return }
        var cacheItem = cache[indexPath] ?? ViewModelCacheItem()
        cacheItem.supplementaryItems[type] = item
        cache[indexPath] = cacheItem
    }
    
}
