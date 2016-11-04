//
//  TestCollectionViewCell.swift
//  Boomerang
//
//  Created by Stefano Mondino on 03/11/16.
//
//

import UIKit
import Boomerang

final class TestItemViewModel: ViewModelItemType {
    

    public var model: ViewModelItemType.T
    var title:String { return self.model.title ?? "" }
    var itemIdentifier: ListIdentifier = "TestCollectionViewCell"
//    var model:Item
    
    public init(model: ViewModelItemType.T) {
        self.model = model
    }
}

final class TestCollectionViewCell: UICollectionViewCell , ViewModelBindable {

    @IBOutlet weak var lbl_title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func bindViewModel(_ viewModel:ViewModelType?) {
        guard let vm = viewModel as? TestItemViewModel else {
            return
        }
        self.lbl_title.text = vm.title
    }
}
