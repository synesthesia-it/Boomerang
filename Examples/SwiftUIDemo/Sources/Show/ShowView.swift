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
        ZStack {
            AsyncImage(url: viewModel.image,
                       content: { image in
                image.resizable()
                    .aspectRatio(210.0 / 270.0, contentMode: .fit)

            },
                       placeholder: {
                ProgressView()
            })
                
            Text(viewModel.title)
//                .foregroundColor(.white)
//            .padding(30)
//                .background(Color(.blue))
//                .mask(Circle())
        }

//            Text(viewModel.title)
//            .onAppear { self.viewModel.reload() }
    }
}
struct ShowListView_Previews: PreviewProvider {
    static var previews: some View {
        ShowListView(viewModel: ShowViewModel.demo())
    }
}
