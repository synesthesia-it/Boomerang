//
//  ScheduleViewModel.swift
//  SwiftUIDemo
//
//  Created by Stefano Mondino on 03/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Combine
import Boomerang
import RxSwift

class ScheduleViewModel: ViewModel, NavigationViewModel, ObservableObject {

    var uniqueIdentifier: UniqueIdentifier = UUID()

    var cancellables: [AnyCancellable] = []

    var onNavigation: (Route) -> Void = { _ in }

    let layoutIdentifier: LayoutIdentifier

    @Published var currentSelection: IdentifiableViewModel?
    @Published var sections: [Section] = []
    
    init(identifier: SceneIdentifier = .schedule) {
        self.layoutIdentifier = identifier
    }

    static func demo() -> ScheduleViewModel {
        let viewModel = ScheduleViewModel()

        viewModel.sections = [Section(id: "Schedule",
                               items: (0..<20).map { ShowViewModel.demo($0)})]
        return viewModel
    }

    func reload() {
        URLSession.shared.dataTaskPublisher(for: URL(string: "https://api.tvmaze.com/schedule")!)
            .tryMap { data, _ in
                try JSONDecoder().decode([Episode].self, from: data)
            }
            .catch { _ in Just([])}
            .map {
                [Section(id: "Schedule",
                         items: $0.map { ShowViewModel(episode: $0)})]
                
            }
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .assign(to: &$sections)
    }
    func selectItem(at indexPath: IndexPath) { }
}
