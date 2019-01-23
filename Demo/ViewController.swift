//
//  ViewController.swift
//  Demo
//
//  Created by Stefano Mondino on 21/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Boomerang

extension String: ModelType { }

extension String: ReusableListIdentifier {
    public var name: String { return self }
    public var className: AnyClass? {
        if self.shouldBeEmbedded {
            return nil
        } else {
            return TestCollectionViewCell.self
        }
    }
    public var shouldBeEmbedded: Bool { return self.contains("Cell") == false }
}

struct TestItemViewModel: IdentifiableItemViewModelType {
    var identifier: Identifier = "TestCollectionViewCell"
    var model: ModelType? { return title }
    var date: Date = Date()
    var title: String
    static var colors = [UIColor.red, .green,.blue, .yellow, .purple]
    var color: UIColor {
        if let i = Int(title), i < TestItemViewModel.colors.count {
            return TestItemViewModel.colors[i]
        }
        return UIColor.darkGray
    }
    
    init(model: String) {
        self.title = model
    }
}

final class TestCollectionViewCell: UICollectionViewCell, ViewModelCompatible {
    typealias ViewModel = TestItemViewModel
    func configure(with viewModel: TestItemViewModel?) {
        self.backgroundColor = viewModel?.color
    }
}



struct TestListViewModel: ListViewModel {
    typealias DataType = [String]
    var dataHolder: DataHolder = DataHolder()
    init() {
        dataHolder = DataHolder(data: group(.just((0..<5).map {"\($0)"})))
    }
    func convert(model: ModelType, at indexPath: IndexPath, for type: String?) -> ItemViewModelType? {
        switch model {
        case let model as String : return TestItemViewModel(model: model)
        default: return nil
        }
    }
    
    func group(_ observable: Observable<[String]>) -> Observable<DataGroup> {
        return observable.map {
            DataGroup($0)
        }
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = TestListViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.boomerang.configure(with: viewModel)
        viewModel.load()
        
        let item = UIBarButtonItem(title: "ADD", style: .done, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = item
        
        item.rx.tap
            .bind {[weak self] _ in self?.viewModel.dataHolder.insert(["4"], at: IndexPath(item: 5, section: 0))}
            .disposed(by: disposeBag)
        
    }


}

