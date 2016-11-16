//
//  ViewModelFactory.swift
//  Boomerang
//
//  Created by Stefano Mondino on 13/11/16.
//
//

import Foundation
import Boomerang
import ReactiveSwift

struct HeaderIdentifier : ListIdentifier {
    var name: String
    var type: String?
}

struct ViewModelFactory {
    static func testViewModel() -> TestViewModel {
        var a:[ModelStructure] = []
        for i in 0...100 {
            a = a + [ModelStructure([
                Item(string:"\(i*1000)"),
                Item(string:"\(i*1000)"),
                Item(string:"\(i*1000)"),
                Item(string:"\(i*1000)"),
                Item(string:"\(i*1000)"),
                
                Item(string:"(i+1)")
                ],
                                    sectionModel:Item(string:"Title \(i)"))]
        }
        let full = ModelStructure(children:a)
        return TestViewModel(dataProducer: SignalProducer(value:full))
    }
}

extension ViewModelFactory {
    static func anotherTestViewModel() -> ViewModelType {
        var a:[ModelStructure] = []
        for i in 0...100 {
            a = a + [ModelStructure([
                Item(string:"2^\(i) = \(pow(2, i))"),
                Item(string:"2^\(i) = \(pow(2, i))"),
                Item(string:"2^\(i) = \(pow(2, i))"),
                Item(string:"2^\(i) = \(pow(2, i))"),
                Item(string:"2^\(i) = \(pow(2, i))"),
                Item(string:"2^\(i) = \(pow(2, i))")
                ],
                                    sectionModel:Item(string:"Title \(i)"))]
        }
        let full = ModelStructure(children:a)
        return TestViewModel(dataProducer: SignalProducer(value:full))
    }
}
