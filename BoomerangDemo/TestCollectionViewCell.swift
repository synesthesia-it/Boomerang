//
//  TestCollectionViewCell.swift
//  Boomerang
//
//  Created by Stefano Mondino on 03/11/16.
//
//

import UIKit
import Boomerang
import ReactiveSwift
import ReactiveCocoa

extension String : ModelType {
    public var title: String? {return self}
}

final class TestItemViewModel: ItemViewModelType {
    
    
    public var model: ItemViewModelType.Model = ""
    var title:String { return self.model.title ?? "" }
    var customTitle:String?
    var itemIdentifier: ListIdentifier = "TestCollectionViewCell"
    
    convenience init(model: Item) {
        self.init(model:model as ItemViewModelType.Model)
        self.customTitle = model.string
    }
}

final class TestCollectionViewCell: UICollectionViewCell , ViewModelBindable {
    
    var viewModel: ViewModelType?
    @IBOutlet weak var lbl_title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func bindViewModel(_ viewModel:ViewModelType?) {
        guard let vm = viewModel as? TestItemViewModel else {
            return
        }
        self.lbl_title.text = vm.customTitle
    }
}
