//
//  ShowDetailUseCase.swift
//  TVMaze
//
//  Created by Stefano Mondino on 24/05/2020.
//  Copyright © 2020 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
class ShowDetailUseCase {
    func detail(for show: WithShow) -> Observable<Show> {
        URLSession.shared
            .rx
            .getEntity(Show.self, from: .showDetail("\(show.show.id)"))
    }
}
