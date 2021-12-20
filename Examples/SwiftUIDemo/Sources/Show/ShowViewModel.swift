//
//  ShowViewModel.swift
//  SwiftUIDemo
//
//  Created by Stefano Mondino on 03/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Combine
import Boomerang

class ShowViewModel: CombineViewModel, ObservableObject {
    var cancellables: [AnyCancellable] = []
    let layoutIdentifier: LayoutIdentifier
    var uniqueIdentifier: UniqueIdentifier
    var title: String
    let image: URL
    let show: Show

    static func demo(_ count: Int = 1) -> ShowViewModel {

        return ShowViewModel(title: "This is test number \(count)")
    }
    private init(title: String) {
        self.layoutIdentifier = ViewIdentifier.show
        self.uniqueIdentifier = title
        self.show = Show.mock
        self.title = title
        self.image = URL(fileURLWithPath: ".")
    }

    var id: String {
        return uniqueIdentifier.stringValue
    }

    init(episode: Episode, identifier: ViewIdentifier = .show) {
        self.layoutIdentifier = identifier
        self.title = episode.name
        self.show = episode.show
        self.uniqueIdentifier = self.title + "_\(show.id)"
        self.image = episode.show.image?.medium ?? .init(fileURLWithPath: "")
//        if let img = episode.show.image?.medium {
//            self.img = URLSession.shared.rx.data(request: URLRequest(url: img))
//                .map { UIImage(data: $0) }
//                .share(replay: 1, scope: .forever)
//        } else {
//            self.img = .just(UIImage())
//        }

    }
}
