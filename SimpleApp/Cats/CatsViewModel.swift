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


final class CatsViewModel : ListViewModelType, EditableViewModel {
    var dataHolder: ListDataHolderType = ListDataHolder()
    
    func itemViewModel(fromModel model: ModelType) -> ItemViewModelType? {
        guard let item = model as? Cat else {
            return nil
        }
        return ViewModelFactory.catItem(with:item)
    }
    
    func canMoveItem(atIndexPath indexPath: IndexPath) -> Bool {
        return true
    }
    func moveItem(fromIndexPath from: IndexPath, to: IndexPath) {
        self.dataHolder.move(from: from, to: to)
    }
    var listIdentifiers: [ListIdentifier] {
        return [CellIdentifiers.cat]
    }
    
    init() {
//        self.dataHolder = ListDataHolder(withModels: Cat.all)
        self.dataHolder = ListDataHolder(data: Observable<[Cat]>.just(Cat.all)
            .map({ModelStructure(children:[ModelStructure($0)])})
            
            , more:Observable<[Cat]>.just(Array(Cat.all.prefix(upTo: 4))).map({ModelStructure($0)}))
    }
}
