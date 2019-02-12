//
//  Utilities.swift
//  BoomerangTests
//
//  Created by Stefano Mondino on 20/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
@testable import Boomerang

extension DataHolder {
    func delayedStart() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            self.start()
        }
    }
    func forceViewModelConversionOnReload() {
        self.updates.subscribe(onNext: {[weak self] in
            switch $0 {
            case .reload(let update): update()
            default: break
            }
        }).disposed(by: disposeBag)
    }
}

extension ListViewModelType {
    func delayedLoad() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            self.load()
        }
    }
}

struct CollectionTestItemViewModel: ItemViewModelType {
    var identifier: Identifier = "TestCollectionViewCell"
    var model: ModelType? { return title }
    var date: Date = Date()
    var title: String
    init(model: String) {
        self.title = model
    }
}

struct TableTestItemViewModel: ItemViewModelType {
    var identifier: Identifier = "TestTableViewCell"
    var model: ModelType? { return title }
    var date: Date = Date()
    var title: String
    init(model: String) {
        self.title = model
    }
}

final class TestCollectionViewCell: UICollectionViewCell, ViewModelCompatible {
    func configure(with viewModel: CollectionTestItemViewModel) {
         self.backgroundColor = .green
    }
}


final class TestTableViewCell: UITableViewCell, ViewModelCompatible {
    func configure(with viewModel: TableTestItemViewModel) {
        self.backgroundColor = .green
    }
}

class ViewController: UIViewController {
    
    var testTable:Bool = true
    
    required init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, testTable:Bool = true) {
        
        self.testTable = testTable
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func loadView() {
        super.loadView()
        
        if self.testTable{
            let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
            self.view = tableView
        }else{
            
             let layout = UICollectionViewFlowLayout()
             layout.itemSize = CGSize(width: 50, height: 50)
             
             let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 300, height: 300), collectionViewLayout: layout)
             self.view = collectionView
        }
    }
}
