//
//  APIViewModel.swift
//  Demo
//
//  Created by Stefano Mondino on 27/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import RxSwift

class ScheduleViewModel: ListViewModel, SceneViewModelType, InteractionViewModelType {
    
    lazy var selection: Selection = self.defaultSelection()
    
    var sceneIdentifier: SceneIdentifier = Identifiers.Scenes.schedule
    
    func group(_ observable: Observable<[Show]>) -> Observable<DataGroup> {
        return observable.map { DataGroup($0, supplementaryData: [0: [
            Identifiers.SupplementaryTypes.header.name: "Tonight's schedule",
           Identifiers.SupplementaryTypes.footer.name: "Credits: tvmaze.com"
            ]]) }
    }
    
    var dataHolder: DataHolder = DataHolder()
    
    func convert(model: ModelType, at indexPath: IndexPath, for type: String?) -> IdentifiableViewModelType? {
        switch model {
        case let title as String: return HeaderItemViewModel(title: title)
        case let model as Show: return ShowItemViewModel(model: model)
        default: return nil
        }
    }
    
    init() {
        
        let apiCall = DataManager.session.rx
            .data(request: URLRequest(url: URL(string: "https://api.tvmaze.com/schedule")!))
            .map {
                try DataManager.decoder.decode([Show.Episode].self, from: $0)
            }
            .map { $0.map { $0.show } }
        
        dataHolder = DataHolder(data: self.group(apiCall))
    }
    
    func handleSelectItem(_ indexPath: IndexPath) -> Observable<Interaction> {
        guard let model = self.dataHolder[indexPath] else { return .empty() }
        let vm = ScheduleViewModel()
        return .just(.route(NavigationRoute(viewModel:vm)))
    }
}
