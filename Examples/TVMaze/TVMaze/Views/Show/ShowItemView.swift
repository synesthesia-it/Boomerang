//
//  ShowItemView.swift
//  TVMaze
//

import UIKit
import RxSwift
import RxCocoa
import Boomerang

class ShowItemView: UIView, WithViewModel {

    @IBOutlet weak var title: UILabel?
    @IBOutlet weak var image: UIImageView?
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with viewModel: ViewModel) {
        self.disposeBag = DisposeBag()
        guard let viewModel = viewModel as? ShowItemViewModel 
        else { return }
        if let title = self.title {
            title.text = viewModel.title
        }
        if self.isPlaceholderForAutosize { return }
//        if let image = self.image {
//            viewModel.image
//                .asDriver(onErrorJustReturn: UIImage())
//                .startWith(UIImage())
//                .drive(image.rx.image)
//                .disposed(by: disposeBag)
//        }
    }
}
