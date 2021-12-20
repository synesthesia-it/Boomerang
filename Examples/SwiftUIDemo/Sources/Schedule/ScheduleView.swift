//
//  ScheduleView.swift
//  SwiftUIDemo
//
//  Created by Stefano Mondino on 03/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import SwiftUI
import Boomerang

struct ScheduleView: View {
    let factory: SwiftUIViewFactory
    @ObservedObject var viewModel: ScheduleViewModel

    init(viewModel: ScheduleViewModel, factory: SwiftUIViewFactory = MainViewFactory()) {
        self.viewModel = viewModel
        self.factory = factory
    }
    let columns: [GridItem] = [
        .init(.flexible(), spacing: 4),
        .init(.flexible())
    ]
    var body: some View {
        ScrollView {
            LazyVGrid(viewModel.sections,
                      columns: columns,
                      spacing: 4,
                 factory: factory)
        }
            .onAppear { self.viewModel.reload() }
    }
}
struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(viewModel: ScheduleViewModel())
    }
}
