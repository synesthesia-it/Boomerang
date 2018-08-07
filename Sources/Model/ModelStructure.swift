//
//  ModelStructure.swift
//  Boomerang
//
//  Created by Stefano Mondino on 10/11/16.
//
//

import Foundation
import RxSwift
/**
 A wrapper object for custom data structures and Model nesting
 
 Usually, a list of models could be simply initialized with a flat array of models, that will be independently transformed in ItemViewModels and  sequentially rendered by proper UI components (for example, a list of views in a UIScrollView).
 
 Sometimes, nesting is required to section, separate and reorganize data (for example, a UITableView that renders a contact list, with a pinned header for each initial letter)
 
 ModelStructure is a universal wrapper for these kind of nesting. It can be initialized in two different ways:
 
 - with an array of Model objects
 - with an array of ModelStructure objects.
 
 When accessed with an IndexPath, its last index will always match a ModelType object; previous indexes are used to traverse provided hierarchy.
 
 - Note:
 The most common case is two-dimensional ModelStructures, meaning a ModelStructure with single array of child ModelStructures, each one with its models. This is working out-of-the-box with UICollectionView and UITableView. However, multi-dimensional structures are theoretically supported, but will require proper handling on the View layer.
 
 */
public final class ModelStructure {
    
    public static var singleSectionModelIdentifier = ""
    
    public typealias ModelClass = ModelType
    
    /**
     The array of ModelType objects contained by current ModelStructure. If this array has values, the `children` array must be nil
     */
    public var models: [ModelClass]?
    /**
     The array of children ModelStructure objects contained by current ModelStructure. If this array has values, the `models` array must be nil
     */
    public var children: [ModelStructure]?
    
    /**
     A map of models (one or more) that are related to current array of models (or child structures).
     
     For example, in a UITableView, each section can be a header and/or footer, each one represented by its ItemViewModel/ModelType object.
     In a UICollectionView, this is where each supplementary view's underlying models must be stored
     */
    public var sectionModels: [String: ModelClass]?
    
    /**
     Convenience method to retrieve a single section model
     */
    public var sectionModel: ModelClass? {
        return self.sectionModels?[ModelStructure.singleSectionModelIdentifier]
    }
    
    /**
     In a ModelStructure with child structures, it's the count of children.
     If the ModelStructure has no children, 0 is returned.
     */
    public var childrenCount: Int {return self.children?.count ?? 0}
    
    /**
     In a ModelStructure with models and no child structures, it's the count of contained models.
     If the ModelStructure has no models, 0 is returned.
     */
    public var modelCount: Int {return self.models?.count ?? 0}
    
    /**
     Convenience structure with no child structures and 0 models
     */
    public class var empty: ModelStructure {return ModelStructure([])}
    
    /// Used to determine where to begin a partial update in a list
    internal var preferredIndexPath: IndexPath?
    
    /** Initializes a new ModelStructure with an array of Models.
     - Parameters:
        - models: An array of `ModelType` conforming objects intended to be listed somewhere
        - sectionModels: A map of Models with informations related to the whole group of models (ex: a header and a footer model for a UITableView's section)
     
     - Returns: a new ModelStructure
     */
    
    public init (_ models: [ModelClass], sectionModels: [String: ModelClass]? = nil) {
        self.models = models
        self.sectionModels = sectionModels
    }
    
    /** Initializes a new ModelStructure with an array of Models.
     - Parameters:
        - models: An array of `ModelType` conforming objects intended to be listed somewhere
        - sectionModel: A single model with informations related to the whole group of models (ex: a header model for a UITableView's section)
 
     - Returns: a new ModelStructure
     */
    public convenience init (_ models: [ModelClass], sectionModel: ModelClass) {
        self.init(models, sectionModels: [ModelStructure.singleSectionModelIdentifier: sectionModel])
    }
    
    /** Initializes a new ModelStructure with an array of child ModelStructure.
     - Parameters:
     - children: An array of `ModelStructure`s, each one made up by Models or ModelStructures.
     
     - Returns: a new ModelStructure
     */
    
    public init (children: [ModelStructure]? ) {
        self.children = children
    }
    
    /**
     A recursive list of all contained `IndexPath`s
     */
    public func indexPaths() -> [IndexPath] {
        return self.indexPaths(current: nil)
    }
    
    private func indexPaths(current: IndexPath?) -> [IndexPath] {
        let ip = current ?? IndexPath(indexes: [Int]())
        if (self.models != nil) {
            
            let new = self.models?.reduce([], { (accumulator, _) -> [Int] in
                return accumulator + [accumulator.count]
            })
                .map {(n: Int) -> IndexPath in
                    return IndexPath(indexes: ip + [n])
            }
            return new ?? []
        }
        var count = -1
        return self.children?.reduce( [IndexPath](), { (accumulator: [IndexPath], structure: ModelStructure) -> [IndexPath] in
            count += 1
            return accumulator + structure.indexPaths(current: IndexPath(indexes: (ip + [count])))
        }) ?? [IndexPath]()
    }
    /**
     Global count of all contained models. If current structure has child ModelStructures, those are expanded and count is aggregated
     */
    public var count: Int {
        if (self.children != nil) {
            return self.children!.reduce(0, { (count, structure) -> Int in
                return count + structure.count
            })
        }
        return self.models?.count ?? 0
    }
    
    /**
        Model at corresponding index.
     - Returns: a `ModelType` object if indexPath is valid, nil otherwise
     */
    
    public func modelAtIndex(_ index: IndexPath) -> ModelClass? {
        
        if (index.count == 1) {
            guard let i = index.first,
                let count = self.models?.count,
                count > 0 && i < count
                else { return nil}
            
            return self.models?[i]
        }
        guard let children = self.children else {
            let index = index.last ?? 0
            if ((self.models?.count ?? 0) <= index ) { return nil }
            return self.models?[index]
        }
        guard let i = index.first, i < children.count else { return nil}
        
        return children[i].modelAtIndex(index.dropFirst())
    }
    /**
     Section model at corresponding index and for matching string identifier.
     - Parameters:
        - indexPath: IndexPath object, used to retrieve proper section
        - type: a string identifier used to identify proper model in a section. Example: in a UITableView with both header and footer views, it could be "header" or "footer".
     - Returns: a `ModelType` object if indexPath and type are valid, nil otherwise
     */
    
    public func sectionModelAtIndexPath(_ index: IndexPath, forType type: String = ModelStructure.singleSectionModelIdentifier) -> ModelClass? {
        return self.sectionModelsAtIndexPath(index)?[type]
    }
    
    /**
     A map of Section models at corresponding index.
     - Parameters:
        - indexPath: IndexPath object, used to retrieve proper section
     
     - Returns: a `[String:ModelType]` map object if found at indexPath, nil otherwise
     */
    public func sectionModelsAtIndexPath(_ index: IndexPath) -> [String: ModelClass]? {
        if (self.children == nil) {
            return self.sectionModels
        }
        guard let i = index.first,
            let children = self.children,
            i < children.count
            else { return nil }
        return children[i].sectionModels
    }
    /**
     Sequentially returns all contained models or all models contained in child ModelStructures.
    */
    public func allData() -> [ModelClass] {
        if let models = self.models {
            return models
        }
        
        return self.children?.reduce([], { (accumulator, structure) -> [ModelClass] in
            return accumulator + structure.allData()
        }) ?? []
    }
    
    /**
     Deletes an item at matching indexPath. The item is returned
     */
    @discardableResult public func deleteItem(atIndex index: IndexPath) -> ModelClass? {
        if
            let i = index.first,
            (index.count == 1) {
            let model = self.models?[i]
            self.models?.remove(at: i)
            return model
        }
        if let i = index.last,
            let models = self.models,
            self.children == nil && i < models.count {
            let model = self.models?[i]
            self.models?.remove(at: i)
            return model
            
        }
        guard let i = index.first,
            let children = self.children,
            i < children.count else { return nil }
        return self.children?[i].deleteItem(atIndex: index.dropFirst())
    }
    
    /**
     Insert an item at indexPath. The new element is inserted before the element currently at the specified index.
    */
    @discardableResult public func insert(item: ModelClass, atIndex index: IndexPath) -> ModelClass? {
        if (index.count == 1) {
            
            //let model = self.models?[index.first!]
            self.models?.insert(item, at: index.first!)
            return nil //model
        }
        if (self.children == nil) {
            
            self.models?.insert(item, at: index.last ?? 0)
            return nil
            
        }
        return self.children?[(index.first ?? 0)].insert(item: item, atIndex: index.dropFirst())
    }
    
    /**
     Moves the item at starting indexPath to the specified indexPath.
     The moved element is inserted before the element currently at the specified index.
     */
    @discardableResult public func moveItem(fromIndexPath from: IndexPath, to: IndexPath) -> ModelClass? {
        guard let model = self.modelAtIndex(from) else {
            return nil
        }
        self.insert(item: model, atIndex: to)
        self.deleteItem(atIndex: from)
        return model
        
    }
    
    func inserting(_ structure: ModelStructure?) -> ModelStructure {
        guard let structure = structure else { return self }
        guard let ip =  structure.preferredIndexPath,
            let section = ip.first,
            let item = ip.last
            
            else {
                return self + structure
        }
        
        if var models = self.models {
            if (models.count >= item) {
                models.insert(contentsOf: structure.allData(), at: item)
                self.models = models
            }
        } else if var children = self.children {
            if (childrenCount >= section) {
                let childStructure = children[section]
                children[section] = childStructure.inserting(structure)
                self.children = children
            }
        }
        return self
    }
}
func + (left: ModelStructure, right: ModelStructure) -> ModelStructure {

    if left.models != nil && (right.models?.count ?? 0) > 0 {
        left.models! += right.allData()
    } else  if left.children != nil {
        let rightChildren = right.children ?? [ModelStructure(right.models ?? [])]
        left.children! += rightChildren
    }
    return left
    
}

public extension Observable where Element: Collection {
    /**
     Creates an observable that emits a ModelStructure containg the collections' elements if the collection is an array of ModelType objects.
     Basically, it's the same of
     ```
     let observable:Observable<[ModelType]> = ...
     let structured = observable.map { ModelStructure($0) }
     ```
     */
    func structured() -> Observable<ModelStructure> {
        
        return self.map({ (element: Element) -> ModelStructure in
            guard let array = element as? [ModelType] else {
                return ModelStructure([ModelType]())
            }
            return ModelStructure(array)
        })
    }
}
