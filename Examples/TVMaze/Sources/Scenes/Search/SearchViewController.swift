//
//  SearchFileViewController.swift
//  TVMaze
//
//  Created by Andrea De vito on 13/10/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import Boomerang
import RxBoomerang

class SearchViewController: UIViewController {
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var collectionView : UICollectionView!
    @IBAction func textField(_ sender: Any) {
        let text =  textField.rx.textInput
        print ("\(text)")
    }
    let viewModel : SearchViewModel
    let components : ComponentFactory
    var search : [Search] = []
    var disposeBag = DisposeBag()
    var dataSource : CollectionViewDataSource?{
        didSet{
            collectionView.dataSource = dataSource
        }
    }
    var delegate : CollectionViewDelegate?{
        didSet{
            collectionView.delegate = delegate
        }
    }

    init(viewModel: SearchViewModel,  components : ComponentFactory){
        self.viewModel = viewModel
        self.components = components
        super.init(nibName: "SearchViewController", bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.pageTitle
        let dataSource = CollectionViewDataSource(viewModel: self.viewModel, factory: components)
        let sizeCalculator = DynamicSizeCalculator(viewModel: viewModel, factory: components)
        delegate = CollectionViewDelegate(sizeCalculator: sizeCalculator).withSelect(select: { [weak self] indexPath in
            self?.viewModel.selectItem(at: indexPath)
        })
        collectionView.rx.animated(by: viewModel, dataSource: dataSource)
            .disposed(by: disposeBag)
        
        textField.rx.text.bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        viewModel.routes
            .bind(to:self.rx.routes())
            .disposed(by: disposeBag)
        viewModel.reload()
    }



//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return search.count
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let search = search[indexPath.item]
//      //  self.detail(for: search.show)
//
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = (collectionView.frame.width - space * 2 - (columns-1) * space)  / columns
//        let height = width * ratio
//        return CGSize.init(width: width, height: height)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        space
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        UIEdgeInsets(top: space, left: space, bottom: space, right: space)
//    }
//
////    func detail(for show : Show) {
////        let controller = ShowDetailViewController(nibName: "ShowDetailViewController", bundle: nil)
////        controller.show = show
////        if let nav = navigationController  {
////            nav.pushViewController(controller, animated: true)
////        } else {
////        self.present(controller, animated: true, completion: nil)
////    }
////    }
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let name = "EpisodeView"
//
//        collectionView.register(UINib(nibName: name, bundle: nil), forCellWithReuseIdentifier: name)
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: name, for: indexPath) as? EpisodeView
//        else {
//            fatalError("Unable to dequeue PersonCell.")
//        }
//        cell.search = search[indexPath.item]
//        return cell
//    }
    }

    
    
    
    

