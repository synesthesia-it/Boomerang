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
