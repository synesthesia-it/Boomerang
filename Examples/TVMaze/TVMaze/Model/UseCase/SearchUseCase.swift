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
}

class SearchUseCase {
    func shows(query: String) -> Observable<[Show]> {
        URLSession.shared.rx
            .getEntity([ShowSearchResult].self, from: .searchShows(query: query))
            .map { $0.map { $0.show } }
    }
}
