//
//  ModelGroup.swift
//  Boomerang
//
//  Created by Stefano Mondino on 19/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public protocol DataType {}

public struct DataGroup: MutableCollection, RandomAccessCollection {
    public typealias Index = IndexPath
    public typealias Element = DataType?
    public private(set) var models: [DataType] = []
    public private(set) var groups: [DataGroup]? = nil
    static var empty: DataGroup {
        return DataGroup([])
    }
    public init(_ models:[DataType]) {
        self.models = models
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
    private var nestedModels: [DataType] {
        return self.groups?.flatMap { $0.nestedModels } ?? models
    }
    private func group (rescaledTo depth: Int) -> DataGroup {
        let localDepth = self.depth
        if localDepth == depth { return self }
        if localDepth > depth {
            return DataGroup(self.nestedModels)
        }
        return DataGroup(groups: [self.group(rescaledTo: depth - 1)])
    }
    
    public var last: DataType? {
        return groups?.last?.last ?? models.last
    }
    // The upper and lower bounds of the collection, used in iterations
    public var startIndex: Index {
        if let firstGroup = groups?.first {
            return IndexPath(indexes: [0] + firstGroup.startIndex)
        }
        return IndexPath(indexes:[models.startIndex])
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
        return IndexPath(indexes:[models.endIndex])
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
                models.count > lastIndex {
                return models[lastIndex]
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
                models.count > lastIndex,
                let value = newValue {
                models[lastIndex] = value
            }
        }
    }
    public var count: Int {
        return self.groups?.map { $0.count }.reduce(0,+) ?? self.models.count
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
        let lastIndex = self.models.index(after: i.last ?? 0)
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
        let firstIndex = self.models.index(before: i.last ?? 0)
        let startIndex = self.startIndex
        if (startIndex.first ?? 0) >= firstIndex {
            return startIndex
        }
        return IndexPath(indexes: i.dropLast() + [firstIndex])
    }
    mutating public func append(_ model: DataType) {
        self.append([model])
    }
    mutating public func append(_ models: [DataType]) {
        if self.groups != nil { return }
        self.models.append(contentsOf: models)
    }
    mutating public func append(_ group: DataGroup) {
        let depth = self.depth - 1
        self.groups?.append(group.group(rescaledTo: depth))
    }
    mutating public func append(_ groups: [DataGroup]) {
        let depth = self.depth - 1
        self.groups?.append(contentsOf: groups.map { $0.group(rescaledTo: depth)})
    }
    
    mutating public func insert(_ model: DataType, at indexPath: IndexPath) {
        self.insert([model], at: indexPath)
    }
    mutating public func insert(_ models: [DataType], at indexPath: IndexPath) {
        if let groups = self.groups,
            indexPath.count > 1,
            let index = indexPath.first,
            groups.count > index {
            self.groups?[index].insert(models, at: indexPath.dropFirst())
            return
        }
        if let index = indexPath.last {
            if self.models.endIndex < index {
                return
            }
            self.models.insert(contentsOf: models, at: index)
            return
        }
    }
    
    mutating public func delete(at indexPath: IndexPath) {
        if let groups = self.groups,
            indexPath.count > 1,
            let index = indexPath.first,
            groups.count > index {
            self.groups?[index].delete(at: indexPath.dropFirst())
            return
        }
        if let index = indexPath.last {
            if models.count < index { return }
            self.models.remove(at: index)
            return
        }
    }
    
    mutating public func delete(at indexPaths: [IndexPath]) {
        indexPaths.sorted().reversed().forEach { ip in
            self.delete(at: ip)
        }
    }
}

