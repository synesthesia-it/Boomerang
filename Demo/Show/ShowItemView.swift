//
//  TestItemView.swift
//  NewArch
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit
import Boomerang
import RxSwift
import RxCocoa

class TestItemView: UIView, WithItemViewModel {
    
    @IBOutlet weak var testLabel: UILabel!
    
    @IBOutlet weak var posterImage: UIImageView!
    
    var disposeBag = DisposeBag()
    
    func configure(with viewModel: ItemViewModel) {
        self.disposeBag = DisposeBag()
        guard let viewModel = viewModel as? ShowItemViewModel else { return }
        
        self.testLabel.text = viewModel.title
        
        viewModel.img.asDriver(onErrorJustReturn: nil)
            .drive(posterImage.rx.image)
        .disposed(by: disposeBag)
    }
}
