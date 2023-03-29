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

internal protocol DetailSeasonUseCase {
    func detail(season: Season) -> Observable<[Episode]>
}

public class DetailSeasonUseCaseImplementation: DetailSeasonUseCase {

    let repository: TVMazeRepository

    init(repository: TVMazeRepository) {
        self.repository = repository
    }

    func detail(season: Season) -> Observable<[Episode]> {
        return repository.seasonDetail(season: season)
    }
}
