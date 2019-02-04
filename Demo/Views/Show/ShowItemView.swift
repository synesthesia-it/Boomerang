//
//  ShowItemView.swift
//  Demo
//
//  Created by Stefano Mondino on 27/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Boomerang

class ShowItemViewModel: IdentifiableItemViewModelType {
    
    var identifier: Identifier = Identifiers.View.show
    var title: String
    var model: ModelType
    var image: Observable<UIImage?>
    init (model: Show) {
        self.model = model
        self.title = model.name
        self.image = (model.image?.medium?.image() ?? .just(UIImage()))
    }
}

class ShowItemView: UIView, ViewModelCompatible {
    
    @IBOutlet var title: UILabel?
    @IBOutlet var image: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 4
        layer.masksToBounds = true
    }
    func configure(with viewModel: ShowItemViewModel) {
        disposeBag = DisposeBag()
        title?.text = viewModel.title
        if isPlaceholderForAutosize { return }
        
        viewModel.image.startWith(nil).asDriver(onErrorJustReturn: nil).drive(image.rx.image).disposed(by: disposeBag)
    }
    
    override var canBecomeFocused: Bool { return true }
    
    override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
        return true
    }
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [self]
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        
        self.alpha = self.isFocused ? 0.5 : 1
    }
}
