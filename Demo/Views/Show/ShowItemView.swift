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

class TestItemView: UIView, WithViewModel {

    @IBOutlet weak var testLabel: UILabel!

    @IBOutlet weak var posterImage: UIImageView!

    var disposeBag = DisposeBag()

    func configure(with viewModel: ViewModel) {
        self.disposeBag = DisposeBag()
        guard let viewModel = viewModel as? ShowViewModel else { return }

        self.testLabel.text = viewModel.title

        viewModel.img.asDriver(onErrorJustReturn: nil)
            .drive(posterImage.rx.image)
        .disposed(by: disposeBag)
    }
}

extension TestItemView: TableViewCellContained {
    var tableCellAttributes: ContentTableViewCell.Attributes {
        .init(separatorInset: UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 10))
    }
 
}
