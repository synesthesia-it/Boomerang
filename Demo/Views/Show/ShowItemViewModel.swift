//
//  ShowItemViewModel.swift
//  Boomerang
//
//  Created by Stefano Mondino on 05/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import RxCocoa
import RxSwift

class ShowItemViewModel: IdentifiableItemViewModelType {
    
    var identifier: Identifier = Identifiers.Views.show
    var title: String
    var model: ModelType
    var image: Observable<Image?>
    init (model: Show) {
        self.model = model
        self.title = model.name
//        self.image = .just(nil)
        self.image = (model.image?.medium?.image() ?? .just(Image()))
    }
}
