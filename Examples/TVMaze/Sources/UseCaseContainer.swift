//
//  UseCaseContainer.swift
//  TVMaze
//
//  Created by Andrea De vito on 22/10/21.
//

import Foundation
import Boomerang

class UseCaseContainer: DependencyContainer {

    enum Keys: String {
        case schedule
        case search
        case detail
        case castDetail
        case season
        case seasonDetail
    }

    let container: Container<DependencyKey> = .init()

    typealias DependencyKey = Keys
    var schedule: ScheduleUseCase { self[.schedule] }
    var search: SearchUseCase { self[.search] }
    var detail: DetailUseCase { self[.detail] }
    var castDetail: DetailCastUseCase { self[.castDetail] }
    var season: DetailSeasonUseCaseImplementation {self[.season]}
    var seasonDetail: DetailSeasonUseCase {self[.seasonDetail]}

    init() {
        let repository = TVMazeRepository(networkDownloader: NetworkDataSourceImplementation())
        register(for: .schedule, scope: .singleton ) {
            ScheduleUseCaseImplementation(repository: repository)
        }
        register(for: .search, scope: .singleton ) {
            SearchUseCaseImplementation(repository: repository)
        }
        register(for: .detail, scope: .singleton ) {
            DetailUseCaseImplementation(repository: repository)
        }
        register(for: .castDetail, scope: .singleton ) {
            DetailCastUseCaseImplementation(repository: repository)
        }
        register(for: .season, scope: .singleton ) {
            DetailSeasonUseCaseImplementation(repository: repository)
        }
    }
}
