//
//  CatsViewController.swift
//  Boomerang
//
//  Created by Stefano Mondino on 23/10/17.
//
//

import UIKit
import RxSwift
import RxCocoa
import Boomerang


class CatsViewController : UIViewController, ViewModelBindable, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: CatsViewModel?
    var flow:UICollectionViewFlowLayout? {
        return self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }
    var disposeBag: DisposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind(to: ViewModelFactory.cats())
    }
    
    func bind(to viewModel: ViewModelType?) {
        guard let viewModel = viewModel as? CatsViewModel else {
            return
        }
        
        self.viewModel = viewModel
        self.collectionView.bind(to:viewModel)
        self.collectionView.delegate = self

        viewModel.reload()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.autosizeItemAt(indexPath: indexPath, itemsPerLine: 1)
    }
   
}
