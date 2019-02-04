//
//  DataGroup.swift
//  Boomerang
//
//  Created by Stefano Mondino on 19/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public protocol DataType {}



public struct DataGroup: MutableCollection, RandomAccessCollection {
    public typealias SupplementaryData = [Int: [String: DataType]]
    public typealias Index = IndexPath
    public typealias Element = DataType?
    public private(set) var data: [DataType] = []
    public private(set) var supplementaryData: SupplementaryData = [:]
    public private(set) var groups: [DataGroup]? = nil
    static var empty: DataGroup {
        return DataGroup([])
    }
    public init()  {}
    
    public init(_ data:[DataType], supplementaryData: SupplementaryData = [:]) {
        self.data = data
        self.supplementaryData = supplementaryData
    }
    public init(groups: [DataGroup]) {
        let depths = groups.map { $0.depth }
        if Set(depths).count == 1 {
            self.groups = groups
        } else {
            let maxDepth = depths.reduce(0) { $1 > $0 ? $1 : $0 }
            self.groups = groups.map { $0.group(rescaledTo: maxDepth) }
        }
    }
    private var nestedData: [DataType] {
        return self.groups?.flatMap { $0.nestedData } ?? data
    }
    private func group (rescaledTo depth: Int) -> DataGroup {
        let localDepth = self.depth
        if localDepth == depth { return self }
        if localDepth > depth {
            return DataGroup(self.nestedData)
        }
        return DataGroup(groups: [self.group(rescaledTo: depth - 1)])
    }
    
    public var last: DataType? {
        return groups?.last?.last ?? data.last
    }
    
    /// Data used to provide supplementary information for a single item
    /// Example use case: UICollectionView's supplementary view
    public func supplementaryData(at indexPath: IndexPath, for type: String) -> DataType? {
        guard let i = indexPath.last else { return nil }
        return supplementaryData[i]?[type]
    }
    
    // The upper and lower bounds of the collection, used in iterations
    public var startIndex: Index {
        if let firstGroup = groups?.first {
            return IndexPath(indexes: [0] + firstGroup.startIndex)
        }
        return IndexPath(indexes:[data.startIndex])
    }
    public var depth: Int {
        if let groups = self.groups {
            return 1 + groups.map { $0.depth }.reduce(0) { $1 > $0 ? $1 : $0 }
        }
        return 1
    }
    public var endIndex: Index {
        if
            let groups = self.groups,
            let group = groups.last {
            return IndexPath(indexes: [groups.count - 1] + group.endIndex)
        }
        return IndexPath(indexes:[data.endIndex])
    }
    
    public subscript(index: Index) -> Element {
        get {
            if index.count == 0 { return nil }
            if let groups = self.groups,
                let firstIndex = index.first,
                groups.count > firstIndex {
                return groups[firstIndex][index.dropFirst()]
            }
            if
                let lastIndex = index.last,
                data.count > lastIndex {
                return data[lastIndex]
            }
            return nil
        }
        set {
            if index.count == 0 { return }
            if var groups = self.groups,
                let firstIndex = index.first,
                groups.count > firstIndex {
                groups[firstIndex][index.dropFirst()] = newValue
                self.groups = groups
            }
            if
                let lastIndex = index.last,
                data.count > lastIndex,
                let value = newValue {
                data[lastIndex] = value
            }
        }
    }
    public var count: Int {
        return self.groups?.map { $0.count }.reduce(0,+) ?? self.data.count
    }
    // Method that returns the next index when iterating
    public func index(after i: Index) -> Index {
        
        if let groups = self.groups,
            let firstIndex = i.first {
            if groups.count > firstIndex  {
                let group = groups[firstIndex]
                let after = group.index(after:i.dropFirst())
                if after == group.endIndex {
                    return IndexPath(indexes: [((i.first ?? 0) + 1)] + i.dropFirst().map { _ in 0 })
                } else {
                    return IndexPath(indexes:[firstIndex] + after)
                }
            } else {
                return self.endIndex
            }
        }
        let lastIndex = self.data.index(after: i.last ?? 0)
        let endIndex = self.endIndex
        if endIndex.last == lastIndex {
            return endIndex
        }
        return IndexPath(indexes: i.dropLast() + [lastIndex])
    }
    public func index(before i: IndexPath) -> IndexPath {
        
        if let groups = self.groups,
            let firstIndex = i.first {
            if firstIndex > 0  {
                let group = groups[firstIndex]
                let previous = groups[firstIndex - 1]
                let before = group.index(before: i.dropFirst())
                if 0 == i.last {
                    let prevIndex =  previous.endIndex
                    let returnIndex = IndexPath(indexes: [firstIndex - 1] + prevIndex.dropLast() + [(prevIndex.last ?? 1) - 1])
                    return returnIndex
                } else {
                    return IndexPath(indexes:[firstIndex] + before)
                }
            } else {
                if 1 == i.last {
                    return self.startIndex
                } else {
                    return IndexPath(indexes: i.dropLast() + [(i.last ?? 0) - 1])
                }
            }
        }
        let firstIndex = self.data.index(before: i.last ?? 0)
        let startIndex = self.startIndex
        if (startIndex.first ?? 0) >= firstIndex {
            return startIndex
        }
        return IndexPath(indexes: i.dropLast() + [firstIndex])
    }
    mutating public func append(_ data: DataType) {
        self.append([data])
    }
    mutating public func append(_ data: [DataType]) {
        if self.groups != nil { return }
        self.data.append(contentsOf: data)
    }
    mutating public func append(_ group: DataGroup) {
        let depth = self.depth - 1
        self.groups?.append(group.group(rescaledTo: depth))
    }
    mutating public func append(_ groups: [DataGroup]) {
        let depth = self.depth - 1
        self.groups?.append(contentsOf: groups.map { $0.group(rescaledTo: depth)})
    }
    
    mutating public func insert(_ data: DataType, at indexPath: IndexPath) {
        self.insert([data], at: indexPath)
    }
    
    @discardableResult
    mutating public func insert(_ data: [DataType], at indexPath: IndexPath) -> IndexPath? {
        if let groups = self.groups,
            indexPath.count > 1,
            let index = indexPath.first,
            groups.count > index {
            if let inserted = self.groups?[index].insert(data, at: indexPath.dropFirst()) {
                return IndexPath(indexes:[index] + inserted.indices)
            }
            
            return nil
        }
        if let index = indexPath.last {
            if self.data.endIndex < index {
                return nil
            }
            self.data.insert(contentsOf: data, at: index)
            return indexPath.dropLast().appending([Swift.min(index, self.data.count - 1)])
        }
        return nil
    }
    @discardableResult
    mutating public func delete(at indexPath: IndexPath) -> DataType? {
        if let groups = self.groups,
            indexPath.count > 1,
            let index = indexPath.first,
            groups.count > index {
            return self.groups?[index].delete(at: indexPath.dropFirst())
            
        }
        if let index = indexPath.last {
            if data.count <= index { return nil }
            return self.data.remove(at: index)
        }
        return nil
    }
    
    @discardableResult
    mutating public func delete(at indexPaths: [IndexPath]) -> [IndexPath: DataType?] {
        return indexPaths.sorted().reversed().reduce([:]) {accumulator, ip in
            var a = accumulator
            a[ip] = self.delete(at: ip)
            return a
        }
    }
    
    mutating public func move(from start: IndexPath, to end: IndexPath) {
        if start == end { return }
        if let data = self.delete(at: start) {
            self.insert(data, at: end)
        }
    }
}
