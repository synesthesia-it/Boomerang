//
//  DetailUseCase.swift
//  TVMaze
//
//  Created by Andrea De vito on 08/10/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Boomerang
import RxBoomerang
import RxRelay

internal protocol DetailUseCase {
    func detail(show: Show) -> Observable<ShowDetail>
}

public class DetailUseCaseImplementation: DetailUseCase {
    let repository: TVMazeRepository
    init(repository: TVMazeRepository) {
        self.repository = repository

    }

    func detail(show: Show) -> Observable<ShowDetail> {
        repository.episodeDetail(show: show)
    }
}
