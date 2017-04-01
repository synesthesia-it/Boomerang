//
//  ModelStructure.swift
//  Boomerang
//
//  Created by Stefano Mondino on 10/11/16.
//
//

import Foundation
import RxSwift

public protocol ModelType {
    
}

public protocol ModelStructureType {
    var modelCount:Int {get}
    var childrenCount:Int {get}
}

public extension Observable where Element : Collection {
    func structured() -> Observable<ModelStructure> {
        
        return self.map({ (element:Element) -> ModelStructure in
            guard let array = element as? [ModelType] else {
                return ModelStructure([ModelType]())
            }
            return ModelStructure(array)
        })
        //        return self.map({$0 as?[ModelType]}).ignoreNil().map{ModelStructure($0)}
    }
}
public final class ModelStructure : ModelStructureType {
    public static var singleSectionModelIdentifier = ""
    public typealias ModelClass = ModelType
    public var models:[ModelClass]?
    public var children:[ModelStructure]?
    public var sectionModels:[String:ModelClass]?
    public var sectionModel:ModelClass? {
        return self.sectionModels?[ModelStructure.singleSectionModelIdentifier]
    }
    public var childrenCount: Int {return self.children?.count ?? 0}
    public var modelCount: Int {return self.models?.count ?? 0}
    class public var empty:ModelStructure {return ModelStructure([])}
    
    public convenience init (_ models:[ModelClass], sectionModel:ModelClass) {
        self.init(models,sectionModels:[ModelStructure.singleSectionModelIdentifier:sectionModel])
    }
    public init (_ models:[ModelClass], sectionModels:[String:ModelClass]? = nil) {
        self.models = models
        self.sectionModels = sectionModels
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
    
    public var count : Int {
        if (self.children != nil) {
            return self.children!.reduce(0, { (count, structure) -> Int in
                return count + structure.count
            })
        }
        return self.models?.count ?? 0
    }
    
    public func modelAtIndex(_ index: IndexPath) -> ModelClass? {
        
        if (index.count == 1) {
            if (self.models?.count == 0) { return nil }
            return self.models?[index.first!]
        }
        if (self.children == nil) {
            if (self.models?.count == 0) { return nil }
            return self.models?[index.last ?? 0]
        }
        return self.children?[(index.first ?? 0)].modelAtIndex(index.dropFirst())
    }
    
    public func sectionModelAtIndexPath(_ index:IndexPath, forType type:String = ModelStructure.singleSectionModelIdentifier) -> ModelClass? {
        return self.sectionModelsAtIndexPath(index)?[type]
    }
    public func sectionModelsAtIndexPath(_ index:IndexPath) -> [String:ModelClass]? {
        if (self.children == nil) {
            return self.sectionModels
        }
        return self.children?[(index.first ?? 0)].sectionModels
    }
    func allData() -> [ModelClass] {
        if (self.models != nil) {
            return self.models!
        }
        
        return self.children?.reduce([], { (accumulator, structure) -> [ModelClass] in
            return accumulator + structure.allData()
        }) ?? []
    }
    @discardableResult public func deleteItem(atIndex index:IndexPath) -> ModelClass? {
        if (index.count == 1) {
            let model = self.models?[index.first!]
            self.models?.remove(at: index.first!)
            return model
        }
        if (self.children == nil) {
            let model = self.models?[index.last ?? 0]
            self.models?.remove(at: index.last ?? 0)
            return model
            
        }
        return self.children?[(index.first ?? 0)].deleteItem(atIndex:index.dropFirst())
    }
    @discardableResult public func insert(item:ModelClass, atIndex index:IndexPath) -> ModelClass? {
        if (index.count == 1) {
            let model = self.models?[index.first!]
            self.models?.insert(item, at: index.first!)
            return model
        }
        if (self.children == nil) {
            let model = self.models?[index.last ?? 0]
            self.models?.insert(item, at: index.last ?? 0)
            return model
            
        }
        return self.children?[(index.first ?? 0)].insert(item:item, atIndex:index.dropFirst())
    }
    @discardableResult public func moveItem(fromIndexPath from: IndexPath, to: IndexPath) -> ModelClass? {
        guard let model = self.modelAtIndex(from) else {
            return nil
        }
        self.insert(item: model, atIndex: to)
        self.deleteItem(atIndex: from)
        return model
        
        
        
    }
    
}
