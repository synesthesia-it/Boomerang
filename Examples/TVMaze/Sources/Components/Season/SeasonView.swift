//
//  SeasonView.swift
//  TVMaze
//
//  Created by Andrea De vito on 29/10/21.
//

import UIKit
import Boomerang
import Kingfisher

class SeasonView: UIView, WithViewModel {
    private var task: DownloadTask?
    @IBOutlet var name: UILabel!
    @IBOutlet var image: UIImageView!

    func configure(with viewModel: ViewModel) {
        guard let viewModel = viewModel as? SeasonViewModel else {return}
        task?.cancel()
        if isPlaceholderForAutosize {return}
        task = image?.kf.setImage(with: viewModel.image)
        self.name.text = viewModel.name
    }

}
