//
//  SearchUseCase.swift
//  TVMaze
//
//  Created by Stefano Mondino on 22/05/2020.
//  Copyright © 2020 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift

class UseCaseFactory {
    init() {}
    let search = SearchUseCase()
    let schedule: ShowsUseCase = ScheduleUseCase()
}

class SearchUseCase {
    static let minScore: Double = 10.0
    struct Result {
        let shows: [Show]
        let people: [Person]
    }
    
    func shows(query: String, scoring minScore: Double = minScore) -> Observable<[Show]> {
        URLSession.shared.rx
            .getEntity([ShowSearchResult].self, from: .searchShows(query: query))
            .map { $0
                .filter { $0.score >= minScore}
                .map { $0.show }
        }
    }
    func people(query: String, scoring minScore: Double = minScore) -> Observable<[Person]> {
        URLSession.shared.rx
            .getEntity([PersonSearchResult].self, from: .searchPeople(query: query))
            .map { $0
                .filter { $0.score >= minScore}
                .map { $0.person } }
    }
    func all(query: String) -> Observable<Result> {
        shows(query: query).flatMapLatest { shows in
            self.people(query: query)
                .map { people in
                    Result(shows: shows, people: people)
            }
        }
    }
}
