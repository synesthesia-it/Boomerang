//
//  CatItemViewModel.swift
//  Boomerang
//
//  Created by Stefano Mondino on 23/10/17.
//
//

import Foundation
import RxSwift
import Boomerang

final class CatItemViewModel : ItemViewModelType {
    var model:ItemViewModelType.Model
    var itemIdentifier:ListIdentifier = CellIdentifiers.cat
    var title:String
    init(model: Cat) {
        self.model = model
        title = model.title
    }
}
