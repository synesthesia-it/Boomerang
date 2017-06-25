//
//  TestView.swift
//  Boomerang
//
//  Created by Stefano Mondino on 25/06/17.
//
//

import UIKit
import Boomerang
import RxSwift

class TestView : UIView, ViewModelBindable , EmbeddableView{
    
    var viewModel: ViewModelType?
    let disposeBag: DisposeBag = DisposeBag()
    @IBOutlet weak var lbl_title: UILabel!
    
    func bind(to viewModel:ViewModelType?) {
        guard let vm = viewModel as? TestItemViewModel else {
            return
        }
        self.lbl_title.text = vm.customTitle
    }
}
