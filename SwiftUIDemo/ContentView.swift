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
import CombineBoomerang

struct ShowListView: View {
    @ObservedObject var viewModel: ShowViewModel
    var body: some View {
        Text(viewModel.title)
//            .onAppear { self.viewModel.reload() }
    }
}
//
extension List {
    
//    static func sectioned(_ data: [Boomerang.Section], factory: SwiftUIViewFactory) -> some View {
//        let elements: [IdentifiableViewModel] = data
//            .flatMap { $0.items }
//            .compactMap { IdentifiableViewModel(viewModel: $0) }
//
//        return List(elements, id: \.self, rowContent: { _ in
////            factory.view(from: $0)
//            Circle()
//        })
//
//     }
//    init(_ data: [Boomerang.Section], factory: SwiftUIViewFactory, selection: Binding<Set<IdentifiableViewModel>>? = nil) {
//        let elements = data
//            .flatMap { $0.items
//                .compactMap { IdentifiableViewModel(viewModel: $0) }
//        }
//        let builder: ((IdentifiableViewModel) -> AnyView) = {
//             factory.view(from: $0)
//        }
//
//        let content = ForEach(elements, id: \.id) {
//            factory.view(from: $0)
//        }
//
//        List(elements, selection: selection) { (vm) -> AnyView in
//            return factory.view(from: vm)
//        }
//        self.init(selection: selection, content: { content })
//    }
}


struct ContentView: View {
    let factory: SwiftUIViewFactory = SwiftUIViewFactory()
    @ObservedObject var viewModel: ScheduleViewModel
    var body: some View {
        
        List.init(viewModel.sections.flatMap { $0.items.map { IdentifiableViewModel(viewModel: $0)} }) {
            self.factory.view(from: $0)
        }
         .onAppear { self.viewModel.reload() }
//        List<IdentifiableViewModel, AnyView>(viewModel.sections, factory: self.factory)
//            .onAppear { self.viewModel.reload() }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ScheduleViewModel())
    }
}


class ScheduleViewModel: CombineListViewModel, NavigationViewModel, ObservableObject {
    
    var sectionsSubject: CurrentValueSubject<[Boomerang.Section], Never> = CurrentValueSubject([])
    
    var cancellables: [AnyCancellable] = []
    
    var objectWillChange: ObservableObjectPublisher = ObservableObjectPublisher()
    
    var onNavigation: (Route) -> () = { _ in }
    
    let layoutIdentifier: LayoutIdentifier

    var downloadTask: Task?
    
    init(identifier: SceneIdentifier = .schedule) {
        self.layoutIdentifier = identifier
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
    
class ShowViewModel: CombineViewModel, ObservableObject {
    var cancellables: [AnyCancellable] = []
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
