//
//  ShowViewModel.swift
//  Demo
//
//  Created by Stefano Mondino on 24/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Boomerang
import UIKit

class ShowViewModel: ViewModel {
    
    let layoutIdentifier: LayoutIdentifier
    var uniqueIdentifier: UniqueIdentifier
    var title: String
    let show: Show
    let img: Observable<UIImage?>
    init(episode: Episode, identifier: ViewIdentifier = .show) {
        self.layoutIdentifier = identifier
        self.title = episode.name
        self.show = episode.show
        self.uniqueIdentifier = self.title + "_\(episode.show.id)"
        if let img = episode.show.image?.medium {
            self.img = URLSession.shared.rx.data(request: URLRequest(url: img))
                .map { UIImage(data: $0) }
                .share(replay: 1, scope: .forever)
        } else {
            self.img = .just(UIImage())
        }
    }
}
