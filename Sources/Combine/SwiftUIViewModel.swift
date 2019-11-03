//
//  SwiftUIViewModel.swift
//  CombineBoomerang
//
//  Created by Stefano Mondino on 03/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Combine
import Boomerang

public extension ViewModel where Self: ObservableObject, Self.ObjectWillChangePublisher == ObservableObjectPublisher {
    func update() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
}
public extension ListViewModel where Self: ObservableObject, Self.ObjectWillChangePublisher == ObservableObjectPublisher {
    var onUpdate: () -> ()  {
        get { return {[weak self] in self?.update() }}
        set {}
    }
}
