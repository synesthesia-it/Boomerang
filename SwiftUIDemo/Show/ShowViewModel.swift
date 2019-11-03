//
//  ShowViewModel.swift
//  SwiftUIDemo
//
//  Created by Stefano Mondino on 03/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import CombineBoomerang
import Combine
import Boomerang

class ShowViewModel: CombineViewModel, ObservableObject {
    var cancellables: [AnyCancellable] = []
    let layoutIdentifier: LayoutIdentifier
    var uniqueIdentifier: UniqueIdentifier
    var title: String
    let show: Show

    static func demo(_ count: Int = 1) -> ShowViewModel {

        return ShowViewModel(title: "This is test number \(count)")
    }
    private init(title: String) {
        self.layoutIdentifier = ViewIdentifier.show
        self.uniqueIdentifier = title
        self.show = Show(name: "", id: 0, image: nil, genres: [])
        self.title = title
    }

    var id: String {
        return uniqueIdentifier.stringValue
    }

    init(episode: Episode, identifier: ViewIdentifier = .show) {
        self.layoutIdentifier = identifier
        self.title = episode.name
        self.show = episode.show
        self.uniqueIdentifier = self.title + "_\(show.id)"
//        if let img = episode.show.image?.medium {
//            self.img = URLSession.shared.rx.data(request: URLRequest(url: img))
//                .map { UIImage(data: $0) }
//                .share(replay: 1, scope: .forever)
//        } else {
//            self.img = .just(UIImage())
//        }

    }
}
