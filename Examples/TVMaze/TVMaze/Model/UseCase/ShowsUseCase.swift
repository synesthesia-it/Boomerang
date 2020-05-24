//
//  SearchUseCase.swift
//  TVMaze
//
//  Created by Stefano Mondino on 22/05/2020.
//  Copyright © 2020 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift

protocol ShowsUseCase {
    func shows() -> Observable<[WithShow]>
}

class ScheduleUseCase: ShowsUseCase {
    static let minScore: Double = 10.0

    func shows() -> Observable<[WithShow]> {
        URLSession.shared.rx
            .getEntity([Episode].self, from: .schedule)
            .map { $0 }
    }


}

class PersonsShows: ShowsUseCase {
    private let person: Person
    init(person: Person) {
        self.person = person
    }

    func shows() -> Observable<[WithShow]> {
        URLSession.shared.rx
            .getEntity([PersonCastCreditResult].self, from: .personCredit(person))
            .map { $0 }
    }
}
