//
//  ViewModelCache.swift
//  Boomerang
//
//  Created by Stefano Mondino on 20/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

private struct GroupCacheItem<T>: DataType {
    var mainItem: T?
    var supplementaryItems: [String: T] = [:]
}

class GroupCache<T> {
    private var cache = DataGroup()
    internal var isEnabled: Bool = true
    init() { }
    func clear() {
        cache = DataGroup()
    }
    
    func mainItem(at indexPath: IndexPath) -> T? {
        if !isEnabled { return nil }
        return (cache[indexPath] as? GroupCacheItem<T>)?.mainItem
    }
    
    func replaceItem(_ item: T?, at indexPath: IndexPath) {
        if !isEnabled { return }
        
        var cacheItem = cache[indexPath] as? GroupCacheItem<T> ?? GroupCacheItem<T>()
        cacheItem.mainItem = item
        self.cache[indexPath] = cacheItem
//        self.cache = cache
    }
    
    func supplementaryItem(at indexPath: IndexPath, for type: String) -> T? {
        if !isEnabled { return nil }
        return (cache[indexPath] as? GroupCacheItem<T>)?.supplementaryItems[type]
    }
    
    func replaceSupplementaryItem(_ item: T?, at indexPath: IndexPath, for type: String?) {
        if !isEnabled { return }
        var cacheItem = (cache[indexPath] as? GroupCacheItem<T>) ?? GroupCacheItem<T>()
        if let type = type {
            cacheItem.supplementaryItems[type] = item
        } else {
            cache[indexPath] = nil
        }
        cache[indexPath] = cacheItem
    }
    
}
