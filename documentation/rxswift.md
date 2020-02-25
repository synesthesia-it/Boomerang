## RxSwift

RxSwift compatibility is provided with a separated framework (**RxBoomerang**)
RxBoomerang uses RxDataSources under the hood to provide data binding to `UICollectionView` and `UITableView`

Example with `UICollectionView` (from a `RxListViewModel`)

```swift

class ScheduleViewController: UIViewController, WithViewModel {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: RxListViewModel
    
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
    
    private let collectionViewCellFactory: CollectionViewCellFactory
    
    init(nibName nibNameOrNil: String?,
         bundle nibBundleOrNil: Bundle? = nil,
         viewModel: ListViewModel & NavigationViewModel,
         collectionViewCellFactory: CollectionViewCellFactory) {
        self.viewModel = viewModel
        self.collectionViewCellFactory = collectionViewCellFactory
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: ViewModel) {
        guard let viewModel = viewModel as? RxListViewModel else { return }
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = self.viewModel
        let collectionViewDataSource = CollectionViewDataSource(viewModel: viewModel,
                                                                factory: collectionViewCellFactory)
        
        let sizeCalculator = AutomaticCollectionViewSizeCalculator(viewModel: viewModel,
                                                                   factory: collectionViewCellFactory,
                                                                   itemsPerLine: 3)
            .withItemSpacing { _, _ in 10 }
            .withInsets { _ , _ in return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)}
        
        let collectionViewDelegate = CollectionViewDelegate(sizeCalculator: sizeCalculator)
            .withSelect { viewModel.selectItem(at: $0) }

        collectionView.rx
            .animated(by: viewModel, dataSource: collectionViewDataSource)
            .disposed(by: disposeBag)
        
        self.collectionViewDelegate = collectionViewDelegate
        
        viewModel.reload()
        
    }
}
```
