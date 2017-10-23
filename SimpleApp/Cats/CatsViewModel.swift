//
//  CatsViewModel.swift
//  Boomerang
//
//  Created by Stefano Mondino on 23/10/17.
//
//

import Foundation
import RxSwift
import Boomerang
import Action

enum CellIdentifiers : String, ListIdentifier {
    var name: String { return self.rawValue }
    
    var type: String? { return nil }
    
    case cat = "CatItemCollectionViewCell"
}


final class CatsViewModel : ListViewModelType {
    var dataHolder: ListDataHolderType = ListDataHolder()
    
    func itemViewModel(fromModel model: ModelType) -> ItemViewModelType? {
        guard let item = model as? Cat else {
            return nil
        }
        return ViewModelFactory.catItem(with:item)
    }
    

    var listIdentifiers: [ListIdentifier] {
        return [CellIdentifiers.cat]
    }
    
    init() {
//        self.dataHolder = ListDataHolder(withModels: Cat.all)
        self.dataHolder = ListDataHolder(data: Observable<[Cat]>.just(Cat.all).map({ModelStructure($0)}))
    }
}
