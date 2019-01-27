//
//  ModelStructureSpec.swift
//  BoomerangTests
//
//  Created by Stefano Mondino on 19/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//


import Quick
import Nimble
@testable import Boomerang

extension String: ModelType {}
extension Int: ModelType {}
extension Double: ModelType {}
extension DataGroup {
    func combined() -> String {
        return self.compactMap {$0 as? String}.reduce("",+)
    }
}

class ModelGroupSpec: QuickSpec {
    
    
    override func spec() {
        describe("a 'ModelGroup' object") {
            
            context("when initialized with an array of simple model objects") {
                var modelGroup = DataGroup(["A","B","C"])
                beforeEach {
                    modelGroup = DataGroup(["A","B","C"])
                }
                it("should not have other subgroups") {
                    expect(modelGroup.depth) == 1
                    expect(modelGroup.groups).to(beNil())
                }
                it("should be properly indexable") {
                    let indexPath = IndexPath(indexes: [0,0])
                    expect(modelGroup[IndexPath(row: 0, section: 0)] as? String) == "A"
                    expect(modelGroup[IndexPath(item:1, section: 0)] as? String) == "B"
                    expect(modelGroup[IndexPath(indexes: [0,2])] as? String) == "C"
                    expect(modelGroup[IndexPath(indexes:[3,3])]).to(beNil())
                    modelGroup[indexPath] = "D"
                    expect(modelGroup[indexPath] as? String) == "D"
                }
                it ("should be iteratable") {
                    let combined: String = modelGroup.compactMap {$0 as? String}.reduce("",+)
                    expect(combined) == "ABC"
                }
                it ("should allow insertions") {
                    expect(modelGroup.count) == 3
                    modelGroup.append("D")
                    expect(modelGroup.count) == 4
                    expect(modelGroup[IndexPath(indexes: [0,3])] as? String) == "D"
                    modelGroup.append(["E","F"])
                    expect(modelGroup.count) == 6
                    let combined: String = modelGroup.compactMap {$0 as? String}.reduce("",+)
                    expect(combined) == "ABCDEF"
                    let reversed: String = modelGroup.reversed().compactMap { $0 as? String }.reduce("",+)
                    expect(reversed) == "FEDCBA"
                }
                it ("should allow moving items") {
                   
                }
            }
            context ("When an item is moved") {
                var modelGroup = DataGroup()
                beforeEach {
                    modelGroup = DataGroup(["A","B","C","D","E"])
                }
                it ("should work back and forth") {
                    let from = IndexPath(row: 0, section: 0)
                    let to = IndexPath(row: 2, section: 0)
                    modelGroup.move(from: from, to: to)
                    expect(modelGroup.combined()) == "BCADE"
                    modelGroup.move(from: to, to: from)
                    expect(modelGroup.combined()) == "ABCDE"
                }
                it ("should not allow same index modifications") {
                    let to = IndexPath(row: 2, section: 0)
                    modelGroup.move(from: to, to: to)
                    expect(modelGroup.combined()) == "ABCDE"
                }
                
                it ("should not do anything if indexes are out of bounds") {
                    let from = IndexPath(row: 10, section: 10)
                    let to = IndexPath(row: 20, section: 10)
                    modelGroup.move(from: from, to: to)
                    expect(modelGroup.combined()) == "ABCDE"
                }
            }
            context("when initialized with nestedObjects") {
                var modelGroup: DataGroup = DataGroup([])
                beforeEach {
                    modelGroup = DataGroup(groups: [
                        DataGroup(["A", "B", "C"]),
                        DataGroup(["D"]),
                        DataGroup(["E"])
                        ])
                }
                it ("should be iteratable") {
                    let combined: String = modelGroup.compactMap {$0 as? String}.reduce("",+)
                    expect(combined) == "ABCDE"
                    
                    let anotherGroup: DataGroup = DataGroup(groups: [
                        DataGroup(groups: [
                            DataGroup(["A"]),
                            DataGroup(["B","C"])
                            ]),
                        DataGroup(["D"])
                        ])
                    expect(anotherGroup.depth) == 3
                    expect(anotherGroup.compactMap { $0 as? String }.reduce("",+)) == "ABCD"
                }
                
                it("should be properly indexable") {
                    expect(modelGroup.depth) == 2
                    let indexPath = IndexPath(indexes: [0,0])
                    expect(modelGroup.first as? String) == "A"
                    expect(modelGroup.endIndex) == IndexPath(indexes: [2,1])
                    expect(modelGroup.last as? String) == "E"
                    expect(modelGroup[IndexPath(row: 0, section: 0)] as? String) == "A"
                    expect(modelGroup[IndexPath(item:1, section: 0)] as? String) == "B"
                    expect(modelGroup[IndexPath(indexes: [0,2])] as? String) == "C"
                    expect(modelGroup[IndexPath(indexes: [1,0])] as? String) == "D"
                    expect(modelGroup[IndexPath(indexes: [2,0])] as? String) == "E"
                    expect(modelGroup[IndexPath(indexes:[3,3])]).to(beNil())
                    expect(modelGroup[IndexPath(indexes:[0])]).to(beNil())
                    
                    modelGroup[indexPath] = "D"
                    expect(modelGroup[indexPath] as? String) == "D"
                    
                }
                it ("should allow insertions") {
                    expect(modelGroup.count) == 5
                    modelGroup.append(DataGroup(groups: [DataGroup(["F"])]))
                    expect(modelGroup.count) == 6
                    expect(modelGroup[IndexPath(indexes: [3,0])] as? String) == "F"
                    modelGroup.append([
                        DataGroup(groups: [DataGroup(["G"])]),
                        DataGroup(groups: [DataGroup(["H"])])
                        ])
                    expect(modelGroup.count) == 8
                    expect(modelGroup.depth) == 2
                    let combined: String = modelGroup.compactMap {$0 as? String}.reduce("",+)
                    expect(combined) == "ABCDEFGH"
                    
                    modelGroup.insert("Z", at: IndexPath(indexes: [0,0]))
                    expect(modelGroup.compactMap {$0 as? String}.reduce("",+)) == "ZABCDEFGH"
                    
                    modelGroup.insert("Q", at: IndexPath(indexes: [1,1]))
                    expect(modelGroup.compactMap {$0 as? String}.reduce("",+)) == "ZABCDQEFGH"
                    
                    modelGroup.delete(at: IndexPath(indexes: [1,1]))
                    expect(modelGroup.compactMap {$0 as? String}.reduce("",+)) == "ZABCDEFGH"
                    
                    modelGroup.delete(at: [IndexPath(indexes: [0,0]),IndexPath(indexes: [0,1])])
                    expect(modelGroup.compactMap {$0 as? String}.reduce("",+)) == "BCDEFGH"
                }
                
                it ("should behave like a collection") {
                    
                    expect(modelGroup.distance(from: IndexPath(item: 0, section: 0), to: IndexPath(item: 0, section: 2))) == 4
                    
                    expect(modelGroup.distance(from: modelGroup.startIndex, to: modelGroup.endIndex)) == (modelGroup.count + 1)
                    let reversed = modelGroup.reversed()
                        .compactMap { $0 as? String }
                        .reduce("",+)
                    
                    //ABC D E
                    expect(reversed) == "EDCBA"
                }
            }
            context("when initialized with object of different types") {
                var modelGroup: DataGroup = DataGroup(groups: [DataGroup([1])])
                beforeEach {
                    modelGroup = DataGroup(groups: [
                        DataGroup([1, 1.2, "C"]),
                        DataGroup(["D"]),
                        DataGroup(["E"])
                        ])
                }
                it ("should properly reference each object") {
                    expect(modelGroup.depth) == 2
                    expect(modelGroup[IndexPath(item: 0, section: 0)] as? Int) == 1
                    expect(modelGroup[IndexPath(item: 1, section: 0)] as? Double) == 1.2
                    expect(modelGroup[IndexPath(item: 2, section: 0)] as? String) == "C"
                }
            }
        }
    }
}
