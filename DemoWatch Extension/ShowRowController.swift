//
//  ShowRowController.swift
//  DemoWatch Extension
//
//  Created by Stefano Mondino on 05/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import WatchKit
import Boomerang
import RxSwift
import RxCocoa

class ShowRowController: NSObject, ViewModelCompatible {
    var viewModel: ShowItemViewModel?
    
    typealias ViewModel = ShowItemViewModel
    
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var image: WKInterfaceImage!
    var disposeBag = DisposeBag()
    func configure(with viewModel: ShowItemViewModel) {
        disposeBag = DisposeBag()
        titleLabel.setText(viewModel.title)
        
        viewModel.image
            .asDriver(onErrorJustReturn: nil)
            .asObservable()
            .bind { [weak self] img in self?.image.setImage(img) }
            .disposed(by:disposeBag)
    }
    
}
