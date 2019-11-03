//
//  ShowView.swift
//  SwiftUIDemo
//
//  Created by Stefano Mondino on 03/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

struct ShowListView: View {
    @ObservedObject var viewModel: ShowViewModel
    var body: some View {
        Text(viewModel.title)
//            .onAppear { self.viewModel.reload() }
    }
}
