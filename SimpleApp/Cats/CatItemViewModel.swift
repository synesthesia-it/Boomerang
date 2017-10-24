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

import UIKit
final class CatItemViewModel : ItemViewModelType {
    var model:ItemViewModelType.Model
    var itemIdentifier:ListIdentifier = CellIdentifiers.cat
    var title:String
    var image:Observable<UIImage?>
    init(model: Cat) {
        self.model = model
        title = model.title
        
        self.image = URLSession.shared.rx.data(request: URLRequest(url: model.image)).map {
            UIImage(data: $0)
        }.share(replay: 1, scope: SubjectLifetimeScope.forever).startWith(nil)
        
    }
}
