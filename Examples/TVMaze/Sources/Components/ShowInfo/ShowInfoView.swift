//
//  EpisodeView.swift
//  TVMaze
//
//  Created by Andrea De vito on 15/10/21.
//

import UIKit
import Boomerang
import Kingfisher

class ShowInfoView: UIView, WithViewModel {
    private var task : DownloadTask?
    @IBOutlet var text: UILabel!
    @IBOutlet var photo: UIImageView!
    
    func configure(with viewModel: ViewModel) {
        guard let viewModel = viewModel as? ShowInfoViewModel else {return}
        task?.cancel()
        if isPlaceholderForAutosize{return}
        task = photo?.kf.setImage(with: viewModel.image)
        text.text = viewModel.text
    }

}
