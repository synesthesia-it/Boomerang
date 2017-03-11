//
//  TestTableViewCell.swift
//  Boomerang
//
//  Created by Stefano Mondino on 05/03/17.
//
//

import UIKit
import RxSwift
import Boomerang

class TestTableViewCell: UITableViewCell, ViewModelBindable {

    var viewModel: ViewModelType?
    let disposeBag: DisposeBag = DisposeBag()
    @IBOutlet weak var lbl_title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func bindTo(viewModel:ViewModelType?) {
        guard let vm = viewModel as? TestItemViewModel else {
            return
        }
        self.lbl_title.text = vm.customTitle
    }
    
}
class TestHeaderTableViewCell: UITableViewHeaderFooterView, ViewModelBindable {
    
    var viewModel: ViewModelType?
    let disposeBag: DisposeBag = DisposeBag()
    @IBOutlet weak var lbl_title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func bindTo(viewModel:ViewModelType?) {
        guard let vm = viewModel as? TestItemViewModel else {
            return
        }
        self.lbl_title.text = vm.customTitle
    }
    
}
