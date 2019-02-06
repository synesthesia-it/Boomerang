//
//  ShowDetailViewModel.swift
//  Demo
//
//  Created by Stefano Mondino on 05/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import RxSwift
import RxCocoa

class ShowDetailViewModel: ListViewModel, SceneViewModelType, ItemViewModelType {
    func group(_ observable: Observable<Show>) -> Observable<DataGroup> {
        return observable.map {
            DataGroup(
                [HeaderItemViewModel(title: $0.name)] +
                    $0.genres.map { HeaderItemViewModel(title: "Genre: \($0)") }
            )
        }
    }
    
    var sceneIdentifier: SceneIdentifier = Identifiers.Scenes.showDetail
    
    typealias DataType = Show
    
    var dataHolder: DataHolder = DataHolder()
    
    func convert(model: ModelType, at indexPath: IndexPath, for type: String?) -> IdentifiableViewModelType? {
        return nil
    }
    var model: ModelType? { return show }
    var show: Show
    
    init(show: Show) {
        self.show = show
        self.dataHolder = DataHolder(data: self.group(.just(show)))
    }
    
}
