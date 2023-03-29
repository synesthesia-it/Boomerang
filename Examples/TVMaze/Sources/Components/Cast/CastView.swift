//
//  CastView.swift
//  TVMaze
//
//  Created by Andrea De vito on 18/10/21.
//

import UIKit
import Boomerang
import Kingfisher

class CastView: UIView, WithViewModel {
    private var task: DownloadTask?
    @IBOutlet var name: UILabel!
    @IBOutlet var image: UIImageView!

    func configure(with viewModel: ViewModel) {
        guard let viewModel = viewModel as? CastViewModel else {return}
        task?.cancel()
        if isPlaceholderForAutosize {return}
        task = image?.kf.setImage(with: viewModel.image, placeholder: UIImage.init(named: "actor_not_found"))
        self.name.text = viewModel.name

    }

}
