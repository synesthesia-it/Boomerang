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

struct TestItemViewModel: ItemViewModelType {
    var identifier: Identifier = "TestCollectionViewCell"
    var model: ModelType? { return title }
    var date: Date = Date()
    var title: String
    init(model: String) {
        self.title = model
    }
}

final class TestCollectionViewCell: UICollectionViewCell, ViewModelCompatible {
    func configure(with viewModel: TestItemViewModel) {
         self.backgroundColor = .green
    }
}

class ViewController: UIViewController {
    override func loadView() {
        super.loadView()
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        //                    viewController = UICollectionViewController(collectionViewLayout: layout)
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 300, height: 300), collectionViewLayout: layout)
        self.view = collectionView
    }
}
