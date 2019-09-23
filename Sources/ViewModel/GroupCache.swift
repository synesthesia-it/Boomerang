//
//  ViewModelCache.swift
//  Boomerang
//
//  Created by Stefano Mondino on 20/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

private struct GroupCacheItem<T> {
    var mainItem: T?
    var supplementaryItems: [String: T] = [:]
}

class GroupCache<T> {
    private var cache:[IndexPath: GroupCacheItem<T>] = [:]
    internal var isEnabled: Bool = true
    init() { }
     func clear() {
        cache = [:]
    }
    
    func mainItem(at indexPath: IndexPath) -> T? {
        if !isEnabled { return nil }
        return cache[indexPath]?.mainItem
    }
    
     func replaceItem(_ item: T?, at indexPath: IndexPath) {
        if !isEnabled { return }
        
        var cacheItem = cache[indexPath] ?? GroupCacheItem<T>()
        cacheItem.mainItem = item
        self.cache[indexPath] = cacheItem
//        self.cache = cache
    }
    
     func insertItem(item: T?, at indexPath: IndexPath) {
        self.insertItems([item].compactMap { $0 }, at: indexPath)
    }
    
     func insertItems(_ items: [T?], at indexPath: IndexPath) {
        let index = indexPath.last ?? 0
        cache
            .reversed()
            .filter { ($0.key.last ?? 0) >= index }
            .forEach {
                let last = ($0.key.last ?? 0) + items.count
                let index = $0.key.dropLast().appending(last)
                cache[$0.key] = nil
                cache[index] = $0.value
        }
        
        (0..<items.count).forEach { n in
            let ip = indexPath.dropLast().appending(index + n)
            var cacheItem = GroupCacheItem<T>()
            cacheItem.mainItem = items[n]
            cache[ip] = cacheItem
        }
    }
   
     func removeItem(at indexPath: IndexPath) {
        let index = indexPath.last ?? 0
        cache
            .filter { ($0.key.last ?? 0) > index }
            .forEach {
                let last = ($0.key.last ?? 0) - 1
                let index = $0.key.dropLast().appending(last)
                cache[$0.key] = nil
                cache[index] = $0.value
        }
//        }
//        var cacheItem = cache[indexPath] ?? GroupCacheItem<T>()
//        cacheItem.mainItem = item
//        cache[indexPath] = cacheItem
    }
    
    func supplementaryItem(at indexPath: IndexPath, for type: String) -> T? {
        if !isEnabled { return nil }
        return cache[indexPath]?.supplementaryItems[type]
    }
    
     func replaceSupplementaryItem(_ item: T?, at indexPath: IndexPath, for type: String?) {
        if !isEnabled { return }
        var cacheItem = cache[indexPath] ?? GroupCacheItem<T>()
        if let type = type {
            cacheItem.supplementaryItems[type] = item
        } else {
            cache[indexPath] = nil
        }
        cache[indexPath] = cacheItem
    }
    
}
