//
//  ViewController.swift
//  BoomerangDemo
//
//  Created by Stefano Mondino on 03/11/16.
//
//

import UIKit
import Boomerang
import RxSwift
class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UITableViewDelegate, RouterDestination, ViewModelBindable  {
    @IBOutlet weak var collectionView:UICollectionView?
    
    @IBOutlet weak var tableView: UITableView?
    var viewModel:TestViewModel?
    let  disposeBag: DisposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        if (self.viewModel == nil) {
            self.bindTo(viewModel:ViewModelFactory.anotherTestViewModel())
        }
        
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        self.tableView?.estimatedRowHeight = 44
        self.tableView?.sectionHeaderHeight = 44
        self.tableView?.sectionFooterHeight = 44
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel?.reload()
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return tableView.autosizeItemAt(indexPath: indexPath, constrainedToWidth: view.frame.size.width)
//    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.viewForHeader(inSection: section)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
         return tableView.viewForFooter(inSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: 100, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return collectionView.autosizeItemAt(indexPath: indexPath, constrainedToWidth: 140)
        return collectionView.autosizeItemAt(indexPath: indexPath, itemsPerLine: 3)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel!.selection.execute(.item(indexPath))
        //Router.from(self, viewModel: self.viewModel!.select(selection: indexPath)).execute()
        
    }
    
    func bindTo(viewModel: ViewModelType?) {
        
        guard let vm = viewModel as? TestViewModel else {
            return
        }
        self.viewModel = vm
        self.collectionView?.delegate = self
        self.collectionView?.bindTo(viewModel:self.viewModel)
        
        
        self.tableView?.delegate = self
        self.tableView?.bindTo(viewModel:self.viewModel)
        
        _ = vm.selection.executionObservables.switchLatest().subscribe(onNext:{[weak self] sel in
            guard let vm = sel as? ViewModelType else {
                return
            }
            if (self == nil) {
                return
            }
            Router.from(self!, viewModel: vm).execute()
            
        })
        self.viewModel?.reload()
        
    }
}






