//
//  DataGroup.swift
//  Boomerang
//
//  Created by Stefano Mondino on 19/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

/** A generic protocol used to identify an object that can be handled by a DataGroup
 
 Ideal candidates that should conform to `DataType` are `ModelType`s and `ViewModelType`s
 */
public protocol DataType {}

/**
    A collection-type mutable object that is used to group collections of data in order to sort them before ViewModel conversion and display.
 
    A `DataGroup` should be created by a `ListViewModelType` right after obtaining a list of `ModelType` objects from any source of data and should be used to implement custom business logic related to data display, sorting, and grouping.
 
    An example of such grouping is an AddressBook implementation: a plain array of contacts can be rearranged and sorted by last name initial, creating a subgroup for each initial.
 
    `DataGroup` can either provide an array of `DataType` objects or an array of `DataGroup` groups. This makes `DataGroup` a potentially infinite *recursive* structure.
 
    For each array of models, a supplementary Dictionary can be provided, to implement headers/footers/supplementary views in common scenarios.
 */

public struct DataGroup: MutableCollection, RandomAccessCollection {
    
    /** Data type for supplementary data associated to a single data value.
     
    `Int` value represents the last index of each `IndexPath` of current `data` array
     
    For each `Int`, there is one `DataType` object for each `String` value.
    String value must match `kind` of supplementary views in `UICollectionView`
  
    */
    public typealias SupplementaryData = [Int: [String: DataType]]
    public typealias Index = IndexPath
    public typealias Element = DataType?
    
    /**
    Array of current `DataType` objects.
 
     - Important:
     when a `DataGroup` is initialized with a `data` array, it will always have a total count of 0 in its `groups` array and viceversa.
    */
    public private(set) var data: [DataType] = []
    
    /**
    Dictionary of current supplementary `DataType` objects
     
     - SeeAlso:
        - SupplementaryData
     */
    public private(set) var supplementaryData: SupplementaryData = [:]
    
    /**
    Array of child `DataGroup` objects.
 
     - Important:
     when a `DataGroup` is initialized with a `groups` array, it will always have a total count of 0 in its `data` array and viceversa.
    
    */
    public private(set) var groups: [DataGroup]? = nil
    
    /// An empty `DataGroup` with no data and no sub-groups.
    static var empty: DataGroup {
        return DataGroup([])
    }
    public init()  {}
    
    /**
     Creates a new `DataGroup` with provided data
     
     Example:
     
     ```
     let dataGroup = DataGroup(["A","B","C", supplementaryData: [0: ["header":["HEADER"]]]
     ```
     
     - Parameters:
        - data: An array of `DataType` values
        - supplementaryData: a Dictionary of String to DataTypes values associated to each index of `data` array
     */
    public init(_ data:[DataType], supplementaryData: SupplementaryData = [:]) {
        self.data = data
        self.supplementaryData = supplementaryData
    }
    
    /**
     Creates a new `DataGroup` with provided sub-`groups`
     
     Example:
     
     ```
     let subGroup1 = DataGroup(["A","B","C", supplementaryData: [0: ["header":["HEADER 1"]]]
     let subGroup2 = DataGroup(["D","E","F", supplementaryData: [0: ["header":["HEADER 2"]]]
     
     let group = DataGroup(groups:[subGroup1, subGroup2])
     ```
     
     - Parameters:
     - groups: An array of `DataGroup` subgroups
     */
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
    
    /// Last value
    public var last: DataType? {
        return groups?.last?.last ?? data.last
    }
    
    /** Data used to provide supplementary information for a single item
     
    Example use case: UICollectionView's supplementary view
     */
    public func supplementaryData(at indexPath: IndexPath, for type: String) -> DataType? {
        
        guard let i = indexPath.last else { return nil }
        if let groups = self.groups {
            guard let j = indexPath.first, j < groups.count else { return nil }
            return groups[j].supplementaryData(at: indexPath.dropFirst(), for: type)
        }
        return supplementaryData[i]?[type]
    }
    
    
    public var startIndex: Index {
        if let firstGroup = groups?.first {
            return IndexPath(indexes: [0] + firstGroup.startIndex)
        }
        return IndexPath(indexes:[data.startIndex])
    }
    
    /**
     Number of levels of subgroups.
     
     When a `DataGroup` is created with subgroups, depth is equal to the highest of depths of each subgroups.
     When a data groups is created with `data` array, depth is 1.
     
     Common use cases are depth of 1 for plain lists and depth of 2 for sectioned list (like UITableViews or UICollectionViews)
     
     `depth` is thus equal to the maximum number of indexes that current `DataGroup` instance can handle.
    */
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

    public func index(after i: Index) -> Index {
        
        if let groups = self.groups,
            let firstIndex = i.first {
            if groups.count > firstIndex  {
                let group = groups[firstIndex]
                if group.groups == nil &&  group.data.count == 0 {
                    let index = IndexPath(indexes: [((i.first ?? 0) + 1)] + i.dropFirst().map { _ in 0 })
                    return self.index(after: index)
                }
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
    
    /**
     Adds a single `DataType` value at the end of current `data` value.
     - Note:
    If `DataGroup` has subgroups in `groups` property, nothing happens.
    */
    mutating public func append(_ data: DataType) {
        self.append([data])
    }
    
    /**
     Adds a `DataType` array at the end of current `data` value.
     - Note:
     If `DataGroup` has subgroups in `groups` property, nothing happens.
     */
    mutating public func append(_ data: [DataType]) {
        if self.groups != nil { return }
        self.data.append(contentsOf: data)
    }
    /**
     Adds a single `DataGroup` group to current group.
     
     If current group and the new one has different depths, the new one is adapted:
     - if new group's depth is lower than current one, a new group is created with a single group array wrapping the new one.
     - if new group's depth is higher than current one, new group's subgroups are flattened by inner `data` values concatenation until current depth is reached.
     
     - Note:
     If `DataGroup` has no subgroups in `groups` property, inner data is added a the end of current data.
     */
    
    mutating public func append(_ group: DataGroup) {
        let depth = self.depth - 1
        self.groups?.append(group.group(rescaledTo: depth))
    }
    
    /**
     Adds a `DataGroup` array to current group.
     
     
     If current group and the new ones has different depths, each new one is adapted:
     - if new group's depth is lower than current one, a new group is created with a single group array wrapping the new one.
     - if new group's depth is higher than current one, new group's subgroups are flattened by inner `data` values concatenation until current depth is reached.
     
     - Note:
     If `DataGroup` has no subgroups in `groups` property, inner data is added a the end of current data.
     */
    
    mutating public func append(_ groups: [DataGroup]) {
        let depth = self.depth - 1
        self.groups?.append(contentsOf: groups.map { $0.group(rescaledTo: depth)})
    }
    
    /**
     Insert a new value at provided index path, shifting each subsequent item by one
     */
    mutating public func insert(_ data: DataType, at indexPath: IndexPath) {
        self.insert([data], at: indexPath)
    }
    
    /**
     Insert new values starting from provided index path, shifting each subsequent item by new `data` element count
     */
    @discardableResult
    mutating public func insert(_ data: [DataType], at indexPath: IndexPath) -> IndexPath? {
        if let groups = self.groups,
            indexPath.count > 1,
            let index = indexPath.first,
            groups.count > index {
            if let inserted = self.groups?[index].insert(data, at: indexPath.dropFirst()) {
                return IndexPath(indexes:[index] + inserted)
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
    
    /**
        Insert new values starting from provided index path, shifting each subsequent item by new `data` element count
        */
       @discardableResult
       mutating public func insert(_ groups: [DataGroup], at indexPath: IndexPath) -> IndexPath? {
        if indexPath.count == 0 {
            return nil
        }
        if indexPath.count == 1,
            let index = indexPath.last
            {
                self.groups?.insert(contentsOf: groups, at: index)
//                self.groups = groups
                return indexPath
        }
        return insert(groups, at: indexPath.dropLast())

       }
    
    
    
    /**
     Removes and returns (if found) a data value from indexPath.
     */
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
    
    /**
     Removes and returns (if found) a group from indexPath.
     */
    @discardableResult
    mutating public func deleteGroup(at indexPath: IndexPath) -> DataGroup? {
        if indexPath.count == 0 { return nil }
        if let groups = self.groups,
            indexPath.count == 1,
            let index = indexPath.first,
            groups.count > index {
            return self.groups?.remove(at: index)
            
        }
       
        return deleteGroup(at: indexPath.dropLast())
    }
    
    @discardableResult
    mutating public func deleteGroups(at indexPaths: [IndexPath]) -> [IndexPath: DataGroup?] {
        return indexPaths.sorted().reversed().reduce([:]) {accumulator, ip in
            var a = accumulator
            a[ip] = self.deleteGroup(at: ip)
            return a
        }
    }
    /**
     Removes and returns (if found) values from each provided indexPath.
     */
    @discardableResult
    mutating public func delete(at indexPaths: [IndexPath]) -> [IndexPath: DataType?] {
        return indexPaths.sorted().reversed().reduce([:]) {accumulator, ip in
            var a = accumulator
            a[ip] = self.delete(at: ip)
            return a
        }
    }
    
    /**
     Move items across dataGroups, shifting other values accordingly
     */
    
    mutating public func move(from start: IndexPath, to end: IndexPath) {
        if start == end { return }
        if let data = self.delete(at: start) {
            self.insert(data, at: end)
        }
    }
}
