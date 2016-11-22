//
//  ModelStructure.swift
//  Boomerang
//
//  Created by Stefano Mondino on 10/11/16.
//
//

import Foundation


public protocol ModelType {
    var title:String? {get}
}
public protocol ModelStructureType {
    var modelCount:Int {get}
    var childrenCount:Int {get}
}

public final class ModelStructure : ModelStructureType {
    public typealias ModelClass = ModelType
    public var models:[ModelClass]?
    public var children:[ModelStructure]?
    public var sectionModel:ModelClass?
    public var childrenCount: Int {return self.children?.count ?? 0}
    public var modelCount: Int {return self.models?.count ?? 0}
    class public var empty:ModelStructure {return ModelStructure([])}
    
    public init (_ models:[ModelClass], sectionModel:ModelClass? = nil) {
        self.models = models
        self.sectionModel = sectionModel
    }
    public init (children:[ModelStructure]? ) {
        self.children = children
    }
    public func indexPaths() -> [IndexPath] {
        return self.indexPaths(current: nil)
    }
    private func indexPaths(current:IndexPath?) -> [IndexPath] {
        let ip = current ?? IndexPath(indexes: [Int]())
        if (self.models != nil) {
            
            let new = self.models?.reduce([], { (accumulator, item) -> [Int] in
                return accumulator + [accumulator.count]
            })
                .map {(n:Int) -> IndexPath in
                    return IndexPath(indexes: ip + [n])
            }
            return new ?? []
        }
        var count = -1
        return self.children?.reduce( [IndexPath](), { (accumulator:[IndexPath], structure:ModelStructure) -> [IndexPath] in
            count += 1
            return accumulator + structure.indexPaths(current: IndexPath(indexes:(ip + [count])))
        }) ?? [IndexPath]()
    }
    
    var count : Int {
        if (self.children != nil) {
            return self.children!.reduce(0, { (count, structure) -> Int in
                return count + structure.count
            })
        }
        return self.models?.count ?? 0
    }
    
    func modelAtIndex(_ index: IndexPath) -> ModelClass? {
        
        if (index.count == 1) {
            return self.models?[index.first!]
        }
        if (self.children == nil) {
            return self.models?[index.last ?? 0]
        }
        return self.children?[(index.first ?? 0)].modelAtIndex(index.dropFirst())
    }
    
    func allData() -> [ModelClass] {
        if (self.models != nil) {
            return self.models!
        }
        return self.children?.reduce([], { (accumulator, structure) -> [ModelClass] in
            return accumulator + structure.allData()
        }) ?? []
    }
    
}
