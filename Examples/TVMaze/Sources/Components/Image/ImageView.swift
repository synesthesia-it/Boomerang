//
//  TitleView.swift
//  TVMaze
//
//  Created by Andrea De vito on 18/10/21.
//

import UIKit
import Boomerang
import Kingfisher

class ImageView: UIView, WithViewModel {
    private var task : DownloadTask?
    @IBOutlet var image: UIImageView!
    
    func configure(with viewModel: ViewModel) {
        guard let viewModel = viewModel as? ImageVieModel else {return}
        task?.cancel()
        if isPlaceholderForAutosize{return}
        task = image?.kf.setImage(with: viewModel.url)
            
  
        
    }
    
    
}
