//
//  TableViewScheduleViewModel.swift
//  Demo
//
//  Created by Alberto Bo on 08/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//


import Foundation
import Boomerang
import RxSwift


class SupplementaryViewModel: NSObject, DataType{
    
    var title:String
    var height:CGFloat
    
    init(title:String, height:CGFloat){
        self.title = title
        self.height = height
        super.init()

    }
}


class TableViewScheduleViewModel: ListViewModel, SceneViewModelType, InteractionViewModelType {
   
    lazy var selection: Selection = self.defaultSelection()
    
    var sceneIdentifier: SceneIdentifier = Identifiers.Scenes.tableViewSchedule
    
    var dataHolder: DataHolder = DataHolder()

    let header = SupplementaryViewModel(title: "Tonight's schedule", height: 80.0)
    let footer = SupplementaryViewModel(title: "Credits: tvmaze.com", height: 30.0)
    
    func group(_ observable: Observable<[Show]>) -> Observable<DataGroup> {
        return observable.map { DataGroup($0, supplementaryData: [0: [
            TableViewHeaderType.header.identifier: "Tonight's schedule",
            TableViewHeaderType.footer.identifier: "Credits: tvmaze.com"
            ]]) }

    }
    
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
            }.map {
                $0.map { $0.show }
            }
        
        dataHolder = DataHolder(data: self.group(apiCall))
    }
    
    func handleSelectItem(_ indexPath: IndexPath) -> Observable<Interaction> {
        guard let model = self.dataHolder[indexPath] as? Show else { return .empty() }
        let vm = ShowDetailViewModel(show: model)
        return .just(.route(NavigationRoute(viewModel:vm)))
    }
    
    func handleCustom(_ interaction: CustomInteraction) -> Observable<Interaction> {
        return .empty()
    }
}

