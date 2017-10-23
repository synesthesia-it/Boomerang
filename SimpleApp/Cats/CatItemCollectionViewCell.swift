//
//  CatItemCollectionViewCell.swift
//  Boomerang
//
//  Created by Stefano Mondino on 23/10/17.
//
//

import UIKit
import Boomerang
import RxSwift
import Action
import RxCocoa

class CatItemCollectionViewCell: UICollectionViewCell, ViewModelBindable {
    
    var viewModel:ItemViewModelType?
    var disposeBag = DisposeBag()
    @IBOutlet weak var titleLabel:UILabel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func bind(to viewModel: ViewModelType?) {
        guard let viewModel = viewModel as? CatItemViewModel else {
            return
        }
        self.viewModel = viewModel
        self.titleLabel?.text = viewModel.title
    }
}
