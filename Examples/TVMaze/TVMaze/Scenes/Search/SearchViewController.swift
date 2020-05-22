//
//  SearchViewController.swift
//  App
//

import UIKit
import Boomerang
import UIKitBoomerang
import RxBoomerang
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!

    var viewModel: SearchViewModel
    
    var collectionViewDataSource: CollectionViewDataSource? {
        didSet {
            self.collectionView.dataSource = collectionViewDataSource
            self.collectionView.reloadData()
        }
    }
    
    var collectionViewDelegate: CollectionViewDelegate? {
        didSet {
            self.collectionView.delegate = collectionViewDelegate
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    var disposeBag = DisposeBag()
    private let collectionViewCellFactory: UICollectionViewCellFactory
    
    init(nibName: String?,
         bundle: Bundle? = nil,
         viewModel: SearchViewModel,
         collectionViewCellFactory: UICollectionViewCellFactory) {
        self.viewModel = viewModel
        self.collectionViewCellFactory = collectionViewCellFactory
        super.init(nibName: nibName, bundle: bundle)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        return searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"

        self.navigationItem.searchController = searchController

        searchController.searchBar.rx
            .text
            .distinctUntilChanged()
            .bind(to: viewModel.searchString)
            .disposed(by: disposeBag)

        viewModel.searchString
            .asDriver()
            .distinctUntilChanged()
            .drive(searchController.searchBar.rx.text)
            .disposed(by: disposeBag)

        let viewModel = self.viewModel
        let collectionViewDataSource = CollectionViewDataSource(viewModel: viewModel,
                                                                factory: collectionViewCellFactory)

        let spacing: CGFloat = 10
        let sizeCalculator = AutomaticCollectionViewSizeCalculator(viewModel: viewModel,
                                                                   factory: collectionViewCellFactory, itemsPerLine: 3)
            .withItemSpacing { _, _ in return spacing }
            .withLineSpacing { _, _ in return spacing }
            .withInsets { _, _ in return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing) }
            
        
        let collectionViewDelegate = CollectionViewDelegate(sizeCalculator: sizeCalculator)
            .withSelect { viewModel.selectItem(at: $0) }
        
        collectionView.backgroundColor = .clear

        collectionView.rx
            .animated(by: viewModel, dataSource: collectionViewDataSource)
            .disposed(by: disposeBag)
        
        self.collectionViewDelegate = collectionViewDelegate        
        
        viewModel.routes
            .bind(to: self.rx.routes())
            .disposed(by: disposeBag)
        
        viewModel.reload()
        
    }
}

extension SearchViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {

//        viewModel.searchString.accept(searchController.searchBar.text ?? "")
    }
}
