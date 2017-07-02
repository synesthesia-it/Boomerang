//
//  ViewModelFactory.swift
//  Boomerang
//
//  Created by Stefano Mondino on 13/11/16.
//
//

import Foundation
import Boomerang


struct HeaderIdentifier : ListIdentifier {
    var name: String
    var type: String?
}

struct ViewModelFactory {
    static func item(model:ModelType) -> ViewModelType {
        return self.testViewModel()
    }
    static func testViewModel() -> TestViewModel {
        var a:[ModelStructure] = []
        for i in 0...2 {
            a = a + [ModelStructure([
                Item(string:"\(i*1000)"),
                Item(string:"\(i*1000)"),
                Item(string:"\(i*1000)"),
                Item(string:"\(i*1000)"),
                Item(string:"\(i*1000)"),
                
                Item(string:"(i+1)")
                ],
                                    sectionModels:[TableViewHeaderType.header.identifier:Section(string:"Header \(i)"),TableViewHeaderType.footer.identifier:Section(string:"Footer \(i)")])]
        }
        let full = ModelStructure(children:a)
        return TestViewModel(data: .just(full))
        //return TestViewModel(dataProducer: SignalProducer(value:full))
    }
}

extension ViewModelFactory {
    static func anotherTestViewModel() -> ViewModelType {
        return testViewModel()
        var a:[Item] = (0...10).map {Item(string:"\($0)")}
        return TestViewModel(data:.just(ModelStructure(a)))
//        for i in 0...10 {
//            a = a + [ModelStructure([
//                Item(string:"2^\(i) = \(pow(2, i))"),
//                ],
//                                    sectionModel:Item(string:"Title \(i)"))]
//        }
//        let full = ModelStructure(children:a)
//         return TestViewModel(data: .just(full))
    }
}
