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
//        let item = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
//        item.rx.bind(to: viewModel.dataHolder.moreAction, input: nil)
//        self.navigationItem.rightBarButtonItem = item
        
        let refresh = UIRefreshControl()
        refresh.rx.bind(to: viewModel.dataHolder.reloadAction, controlEvent: refresh.rx.controlEvent(.allEvents), inputTransform: {_ in return nil})
        viewModel.dataHolder.reloadAction.executing.asDriver(onErrorJustReturn: false).drive(refresh.rx.isRefreshing).disposed(by:disposeBag)
        self.collectionView.addSubview(refresh)
        
        viewModel.reload()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 60, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.autosizeItemAt(indexPath: indexPath, itemsPerLine: 1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height  + 100 {
            self.viewModel?.dataHolder.moreAction.execute(nil)
        }
    }
   
}
