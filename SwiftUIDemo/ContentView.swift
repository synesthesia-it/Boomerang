//
//  ContentView.swift
//  SwiftUIDemo
//
//  Created by Stefano Mondino on 01/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import SwiftUI
import Boomerang
import Combine
struct ContentView: View {
    @ObservedObject var viewModel: ScheduleViewModel
    var body: some View {
        List(viewModel.sections
            .flatMap { $0.items }
            .compactMap { $0 as? ShowViewModel }) {
                Text($0.title)
        }.onAppear { self.viewModel.reload() }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ScheduleViewModel())
    }
}


class ScheduleViewModel: ViewModel, ListViewModel, NavigationViewModel, ObservableObject {
    var onUpdate: () -> () = {}
    
    var objectWillChange: ObservableObjectPublisher = ObjectWillChangePublisher()
    
    var sections: [Boomerang.Section] = [] {
        didSet {
                onUpdate()
        }
    }
    var onNavigation: (Route) -> () = { _ in }
    
    let layoutIdentifier: LayoutIdentifier

    var downloadTask: Task?
    
    init(identifier: SceneIdentifier = .schedule) {
        self.layoutIdentifier = identifier
        self.onUpdate = {[weak self] in DispatchQueue.main.async { self?.objectWillChange.send() } }
    }
    func reload() {
        downloadTask?.cancel()
        downloadTask = URLSession.shared.getEntity([Episode].self, from: .schedule) {[weak self] result in
            switch result {
            case .success(let episodes):
                self?.sections = [Section(id: "Schedule", items: episodes.map { ShowViewModel(episode: $0)})]
            case .failure(let error):
                print(error)
            }
        }
    }
    func selectItem(at indexPath: IndexPath) {
        if let viewModel = self[indexPath] as? ShowViewModel {
//            onNavigation(NavigationRoute(viewModel: ShowDetailViewModel(show: viewModel.show)))
        }
    }
}
class ShowViewModel: ViewModel, Identifiable {
    
    let layoutIdentifier: LayoutIdentifier
    var uniqueIdentifier: UniqueIdentifier
    var title: String
    let show: Show
    var id: String {
        return uniqueIdentifier.stringValue
    }
    
    init(episode: Episode, identifier: ViewIdentifier = .show) {
        self.layoutIdentifier = identifier
        self.title = episode.name
        self.show = episode.show
        self.uniqueIdentifier = self.title + "_\(show.id)"
//        if let img = episode.show.image?.medium {
//            self.img = URLSession.shared.rx.data(request: URLRequest(url: img))
//                .map { UIImage(data: $0) }
//                .share(replay: 1, scope: .forever)
//        } else {
//            self.img = .just(UIImage())
//        }
        
    }
}
