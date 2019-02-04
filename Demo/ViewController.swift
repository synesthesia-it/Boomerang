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

extension String: ViewIdentifier {
    public var name: String { return self }
    public var className: AnyClass? {
        if self.shouldBeEmbedded {
            return nil
        } else {
            return TestCollectionViewCell.self
        }
    }
    
    public func view<T: UIView>() -> T? {
        return (className as? UIView.Type)?.init() as? T
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
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height: 100)
    }
    func configure(with viewModel: TestItemViewModel) {
        self.backgroundColor = viewModel.color
    }
}



struct TestListViewModel: ListViewModel {
    typealias DataType = [String]
    var dataHolder: DataHolder = DataHolder()
    init() {
        dataHolder = DataHolder(data: group(.just((0..<5).map {"\($0)"})))
    }
    func convert(model: ModelType, at indexPath: IndexPath, for type: String?) -> IdentifiableViewModelType? {
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

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = TestListViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.boomerang.configure(with: viewModel)
        viewModel.load()
        
        let add = UIBarButtonItem(title: "+", style: .done, target: nil, action: nil)
        let delete = UIBarButtonItem(title: "-", style: .done, target: nil, action: nil)
        self.navigationItem.rightBarButtonItems = [delete,add]
        
        add.rx.tap
            .bind {[weak self] _ in self?.viewModel.dataHolder.insert(["4"], at: IndexPath(item: 0, section: 0))}
            .disposed(by: disposeBag)
        
        delete.rx.tap
            .bind {[weak self] _ in self?.viewModel.dataHolder.delete(at: [IndexPath(item: 0, section: 0)])}
            .disposed(by: disposeBag)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.boomerang.automaticSizeForItem(at: indexPath)
    }
}

