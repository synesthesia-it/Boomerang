//
//  EpisodeView.swift
//  TVMaze
//
//  Created by Andrea De vito on 15/10/21.
//

import UIKit
import Boomerang
import Kingfisher

class ScheduleShowView: UIView, WithViewModel {
    private var task : DownloadTask?
  
    @IBOutlet var image: UIImageView!
    
    func configure(with viewModel: ViewModel) {
        guard let viewModel = viewModel as? ScheduleShowViewModel else {return}
        task?.cancel()
        if isPlaceholderForAutosize{return}
        task = image?.kf.setImage(with: viewModel.image)
    }
}
