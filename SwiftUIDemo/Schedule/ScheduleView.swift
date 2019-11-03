//
//  ScheduleView.swift
//  SwiftUIDemo
//
//  Created by Stefano Mondino on 03/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftUIBoomerang
import CombineBoomerang
import Boomerang

struct ScheduleView: View {
    let factory: SwiftUIViewFactory
    @ObservedObject var viewModel: ScheduleViewModel
    
    init(viewModel: ScheduleViewModel, factory: SwiftUIViewFactory = MainViewFactory()) {
        self.viewModel = viewModel
        self.factory = factory
    }
    
    var body: some View {
            List(viewModel.sections,
                 factory: factory,
                 selection: $viewModel.currentSelection)
            .onAppear { self.viewModel.reload() }
    }
}
struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(viewModel: ScheduleViewModel.demo())
    }
}

