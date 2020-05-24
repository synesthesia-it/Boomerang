//
//  HeaderItemView.swift
//  TVMaze
//

import UIKit
import RxSwift
import RxCocoa
import Boomerang

class HeaderItemView: UIView, WithViewModel {

    @IBOutlet weak var title: UILabel?
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with viewModel: ViewModel) {
        self.disposeBag = DisposeBag()
        guard let viewModel = viewModel as? HeaderItemViewModel 
        else { return }
        if let title = self.title {
            title.text = viewModel.title
        }
        if self.isPlaceholderForAutosize { return }

    }
}
