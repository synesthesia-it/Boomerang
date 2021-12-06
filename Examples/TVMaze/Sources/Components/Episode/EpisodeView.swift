//
//  EpisodeView.swift
//  TVMaze
//
//  Created by Andrea De vito on 15/10/21.
//

import UIKit
import Boomerang
import Kingfisher

class EpisodeView: UIView, WithViewModel {
    private var task : DownloadTask?
    @IBOutlet var title: UILabel!
    @IBOutlet var subTitle: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    func configure(with viewModel: ViewModel) {
        guard let viewModel = viewModel as? EpisodeViewModel else {return}
        task?.cancel()
        if isPlaceholderForAutosize{return}
        task = imageView?.kf.setImage(with: viewModel.image, placeholder: UIImage.init(named: "image_not_available"))
        title.text = viewModel.title
        subTitle.text = viewModel.subTitle
        
    }

}
