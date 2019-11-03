//
//  ContentView.swift
//  SwiftUIDemo
//
//  Created by Stefano Mondino on 01/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import SwiftUI
import Boomerang
import Combine
import CombineBoomerang



extension List {
    
//    static func sectioned(_ data: [Boomerang.Section], factory: SwiftUIViewFactory) -> some View {
//        let elements: [IdentifiableViewModel] = data
//            .flatMap { $0.items }
//            .compactMap { IdentifiableViewModel(viewModel: $0) }
//
//        return List(elements, id: \.self, rowContent: { _ in
////            factory.view(from: $0)
//            Circle()
//        })
//
//     }
//    init(_ data: [Boomerang.Section], factory: SwiftUIViewFactory, selection: Binding<Set<IdentifiableViewModel>>? = nil) {
//        let elements = data
//            .flatMap { $0.items
//                .compactMap { IdentifiableViewModel(viewModel: $0) }
//        }
//        let builder: ((IdentifiableViewModel) -> AnyView) = {
//             factory.view(from: $0)
//        }
//
//        let content = ForEach(elements, id: \.id) {
//            factory.view(from: $0)
//        }
//
//        List(elements, selection: selection) { (vm) -> AnyView in
//            return factory.view(from: vm)
//        }
//        self.init(selection: selection, content: { content })
//    }
}




    
