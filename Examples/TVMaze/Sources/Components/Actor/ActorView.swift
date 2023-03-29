//
//  PersonView.swift
//  TVMaze
//
//  Created by Andrea De vito on 5/11/21.
//

import UIKit
import Boomerang
import Kingfisher

class ActorView: UIView, WithViewModel {
    private var task: DownloadTask?
    @IBOutlet var actorInfo: UILabel!
    @IBOutlet var image: UIImageView!

    func configure(with viewModel: ViewModel) {
        guard let viewModel = viewModel as? ActorViewModel else {return}
        task?.cancel()
        if isPlaceholderForAutosize {return}
        task = image?.kf.setImage(with: viewModel.image)
        actorInfo.text = viewModel.actorInfo

    }

}
