//
//  ScheduleView.swift
//  SwiftUIDemo
//
//  Created by Stefano Mondino on 03/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import SwiftUI
import CombineBoomerang
import Boomerang

struct ScheduleView: View {
    let factory: SwiftUIViewFactory = SwiftUIViewFactory()
    @ObservedObject var viewModel: ScheduleViewModel
    var body: some View {
        
        List.init(viewModel.sections.flatMap { $0.items.map { IdentifiableViewModel(viewModel: $0)} }) {
            self.factory.view(from: $0)
        }
         .onAppear { self.viewModel.reload() }
//        List<IdentifiableViewModel, AnyView>(viewModel.sections, factory: self.factory)
//            .onAppear { self.viewModel.reload() }
    }
}
struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(viewModel: ScheduleViewModel())
    }
}

