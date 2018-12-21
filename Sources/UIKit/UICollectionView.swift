//
//  UICollectionView.swift
//  Boomerang
//
//  Created by Stefano Mondino on 02/11/16.
//
//

import UIKit
import RxCocoa
import RxSwift


extension UICollectionReusableView: EmbeddableView {}

private class ViewModelCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    weak var viewModel: ListViewModelType?
    init (viewModel: ListViewModelType) {
        super.init()
        self.viewModel = viewModel
        
    }
    @objc public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewModel: ItemViewModelType? = self.viewModel?.viewModel(atIndex: indexPath)
        var reuseIdentifier = defaultListIdentifier
        if let value = viewModel?.itemIdentifier {
            reuseIdentifier = self.viewModel?.reuseIdentifier(for: value, at: indexPath) ?? value.name
            if value.isEmbeddable {
                collectionView.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
            } else {
                collectionView.register(UINib(nibName: value.name, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
            }
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        (cell as? ViewModelBindableType)?.bind(to: viewModel)
        return cell
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count =  self.viewModel?.dataHolder.modelStructure.value.children?.count ?? 1
        return count
    }
    
    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return (collectionView.viewModel as? EditableViewModel)?.canMoveItem(atIndexPath: indexPath) ?? false
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        (collectionView.viewModel as? EditableViewModel)?.moveItem(fromIndexPath: sourceIndexPath, to: destinationIndexPath)
//        collectionView.moveItem(at: sourceIndexPath, to: destinationIndexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count =  self.viewModel?.dataHolder.modelStructure.value.children?[section].models?.count
        count =  count ?? self.viewModel?.dataHolder.modelStructure.value.models?.count
        return count ?? 0
    }
    
    @objc public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let model = self.viewModel?.dataHolder.modelStructure.value.sectionModelsAtIndexPath(indexPath)?[kind] ?? self.viewModel?.dataHolder.modelStructure.value.sectionModelAtIndexPath(indexPath) {
            
            if let viewModel =  (self.viewModel as? ListViewModelTypeSectionable)?.sectionItemViewModel(fromModel: model, withType: kind) {
                let value = viewModel.itemIdentifier
                let reuseIdentifier = self.viewModel?.reuseIdentifier(for: value, at: indexPath) ?? value.name
                if viewModel.itemIdentifier.isEmbeddable {
                    collectionView.register(ContentCollectionViewCell.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
                } else {
                    collectionView.register(UINib(nibName: value.name, bundle: nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
                }
                
                let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath)
                (cell as? ViewModelBindableType)?.bind(to: viewModel)
                return cell
            }
        }
        
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: EmptyReusableView.emptyReuseIdentifier, for: indexPath)
    }
    struct StaticCellParameters {
        var constraint: NSLayoutConstraint!
        var cell: UIView!
    }
    
    var staticCells = [String: StaticCellParameters]()
    
    func staticCellForSize (at indexPath: IndexPath, width: Float) -> UIView? {
        guard let viewModel = self.viewModel?.viewModel(atIndex: indexPath) else { return nil }
        guard let nib = self.viewModel?.identifier(atIndex: indexPath) else {
            return nil
        }
        
        var parameters = self.staticCells[nib.name]
        
        if (parameters == nil) {
            
            guard let cell = Bundle.main.loadNibNamed(nib.name, owner: self, options: [:])!.first as? UIView else { return nil}
            guard let embeddable = cell as? EmbeddableView else { return nil }
            
            embeddable.customContentView.translatesAutoresizingMaskIntoConstraints = false
            let constraint = NSLayoutConstraint(
                item: embeddable.customContentView,
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: CGFloat(width))
            embeddable.customContentView.addConstraint(constraint)
            embeddable.isPlaceholder = true
            parameters = StaticCellParameters(constraint: constraint, cell: cell)
            
        }
        
        parameters!.constraint?.constant = CGFloat(width)
        (parameters!.cell as? ViewModelBindableType)?.bind(to: viewModel)
        
        var newCells = staticCells
        newCells[nib.name] = parameters
        
        self.staticCells = newCells
        return parameters?.cell
        
    }
    
    func staticCellForSize (at indexPath: IndexPath, height: Float) -> UIView? {
        guard let viewModel = self.viewModel?.viewModel(atIndex: indexPath) else { return nil }
        guard let nib = self.viewModel?.identifier(atIndex: indexPath) else {
            return nil
        }
        
        var parameters = self.staticCells[nib.name]
        
        if (parameters == nil) {
            guard let cell = Bundle.main.loadNibNamed(nib.name, owner: self, options: [:])!.first as? UIView else { return nil}
            guard let embeddable = cell as? EmbeddableView else { return nil }
            
            embeddable.customContentView.translatesAutoresizingMaskIntoConstraints = false
            let constraint = NSLayoutConstraint(
                item: embeddable.customContentView,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: CGFloat(height))
            embeddable.customContentView.addConstraint(constraint)
            embeddable.isPlaceholder = true
            parameters = StaticCellParameters(constraint: constraint, cell: cell)
            
        }
        
        parameters!.constraint?.constant = CGFloat(height)
        (parameters!.cell as? ViewModelBindableType)?.bind(to: viewModel)
        //        self.bindViewModelToCellAtIndexPath(parameters!.cell, indexPath: indexPath, forResize: true)
        var newCells = staticCells
        newCells[nib.name] = parameters
        
        self.staticCells = newCells
        return parameters?.cell
        
    }
    
    func autoSizeForItem(at indexPath: IndexPath, width: Float) -> CGSize {
        let cell = self.staticCellForSize(at: indexPath, width: width) as? EmbeddableView
        cell?.customContentView.setNeedsLayout()
        cell?.customContentView.layoutIfNeeded()
        #if swift(>=4.2)
        let size = cell?.customContentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize) ?? CGSize.zero
        #else
        let size = cell?.customContentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize) ?? CGSize.zero
        #endif
        return size
    }
    
    func autoSizeForItem(at indexPath: IndexPath, height: Float) -> CGSize {
        let cell = self.staticCellForSize(at: indexPath, height: height) as? EmbeddableView
        cell?.customContentView.setNeedsLayout()
        cell?.customContentView.layoutIfNeeded()
        #if swift(>=4.2)
        let size = cell?.customContentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize) ?? CGSize.zero
        #else
        let size = cell?.customContentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize) ?? CGSize.zero
        #endif
        return size
    }
    
}
private struct AssociatedKeys {
    static var viewModel = "viewModel"
    static var bufferTime = "bufferTime"
    static var disposeBag = "disposeBag"
    static var isPlaceholder = "isPlaceholder"
    static var collectionViewDataSource = "collectionViewDataSource"
}

public extension ListViewModelType {
    /// A concrete implementation for `UICollectionViewDataSource` (UIKit requires it to be objc compatible). Value is retained.
    var collectionViewDataSource: UICollectionViewDataSource? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.collectionViewDataSource) as? UICollectionViewDataSource}
        set { objc_setAssociatedObject(self, &AssociatedKeys.collectionViewDataSource, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
}

private class EmptyReusableView: UICollectionViewCell {
    fileprivate static let emptyReuseIdentifier = "_emptyReusableView"
}
/**
 A custom UICollectionViewCell that automatically embeds any UIView
 This class is automatically used by Boomerang to allow any view to be used in any list, and instantly swap (for example) a table view with a collection view without redesigning all the xibs.
 */
open class ContentCollectionViewCell: UICollectionViewCell, ViewModelBindable {
    //Current Item view model
    public var viewModel: ViewModelType?
    /**
     A disposeBag where disposables can be easily stored.
     */
    public var disposeBag: DisposeBag = DisposeBag()
    weak var internalView: UIView?
    ///Constraints between cell and inner view. By defaults, insets are all 0.
    public var insetConstraints: [NSLayoutConstraint] = []
    /** Binds an external itemViewModel to current cell.
     If no content view was previously set, a new one is created from nib and installed.
     View model is then properly bound to inner view.
     */
    public func bind(to viewModel: ViewModelType?) {
        guard let viewModel = viewModel as? ItemViewModelType else {
            return
        }
        
        self.disposeBag = DisposeBag()
        self.viewModel = viewModel
        if (self.internalView == nil) {
            guard let view = Bundle.main.loadNibNamed(viewModel.itemIdentifier.name, owner: self, options: nil)?.first as? UIView else {
                return
            }
            
            self.insetConstraints = self.contentView.addAndFitSubview(view)
            self.internalView = view
        }
        (self.internalView as? ViewModelBindableType)?.bind(to: viewModel)
    }
}

extension UICollectionView: ViewModelBindable {
    /// Current ListViewModel. Retained.
    public var viewModel: ViewModelType? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.viewModel) as? ViewModelType}
        set { objc_setAssociatedObject(self, &AssociatedKeys.viewModel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
    /**
     The amount of time the UICollectionView is given to buffer UI updates before dispatching a batchUpdate.
     This is useful if datasource is asyncrously dispatching updates that are really close in time, but not completely in synch. In this way, strange updates and animations are avoided.
     In most of cases, there's no need to change this value.
     Defaults to 0.2 seconds.
    */
    
    public var updateBufferTime: TimeInterval {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.bufferTime) as? TimeInterval ?? 0.2}
        set { objc_setAssociatedObject(self, &AssociatedKeys.bufferTime, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
    /**
     A lazily-created disposeBag where disposables can be easily stored.
     */
    public var disposeBag: DisposeBag {
        get {
            var disposeBag: DisposeBag
            
            if let lookup = objc_getAssociatedObject(self, &AssociatedKeys.disposeBag) as? DisposeBag {
                disposeBag = lookup
            } else {
                disposeBag = DisposeBag()
                objc_setAssociatedObject(self, &AssociatedKeys.disposeBag, disposeBag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            
            return disposeBag
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.disposeBag, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    /// Binds a list view model to current collectionView and automatically handles cell creations when viewModel gets reloaded.
    public func bind(to viewModel: ViewModelType?) {
        guard let viewModel = viewModel as? ListViewModelType else {
            self.viewModel = nil
            return
        }
        self.disposeBag = DisposeBag()
        self.viewModel = viewModel
        self.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: defaultListIdentifier)
        
        #if swift(>=4.2)
        let headerName = UICollectionView.elementKindSectionHeader
        let footerName = UICollectionView.elementKindSectionFooter
        #else
        let size = cell?.customContentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize) ?? CGSize.zero
        #endif
        
        self.register(EmptyReusableView.self, forSupplementaryViewOfKind: headerName, withReuseIdentifier: EmptyReusableView.emptyReuseIdentifier)
        self.register(EmptyReusableView.self, forSupplementaryViewOfKind: footerName, withReuseIdentifier: EmptyReusableView.emptyReuseIdentifier)
        if (viewModel.collectionViewDataSource == nil) {
            viewModel.collectionViewDataSource = ViewModelCollectionViewDataSource(viewModel: viewModel)
        }
        self.dataSource = viewModel.collectionViewDataSource
        let lockAnimation = BehaviorRelay<Bool>(value: false)
        let customObservable = Observable<Bool>.deferred {[unowned self ] in
            return self.updateBufferTime == 0 ?
                viewModel.dataHolder.commitEditing.asObservable().skip(1).delay(0.0, scheduler: MainScheduler.instance) :
                Observable<Int>.interval(self.updateBufferTime, scheduler: MainScheduler.instance).map {_ in return true}
        }
        let bufferObservable = Observable.combineLatest(customObservable, lockAnimation.asDriver().asObservable()) { time, lock in return time && !lock}.filter {$0}
        
        viewModel
            .dataHolder
            .newDataAvailable
            .asDriver(onErrorJustReturn: nil)
            .asObservable()
            
            .map {[weak self] action -> (() -> Void)? in
                guard let action = action else { return nil }
                var isInsert = false
                var isSection = false
                let items: ResultRangeType?
                switch action {
                case .delete(let _items):
                    items = _items
                case .deleteSections(let _items):
                    items = _items
                    isSection = true
                case   .reload :
                    return nil
                    
                case     .insert(let _items):
                    items = _items
                    isInsert = true
                case     .insertSections(let _items):
                    items = _items
                    isInsert = true
                    isSection = true
                }
                return { [weak self] in
                    
                    guard let range = items else { self?.reloadData() ; return }
                    if isSection && range.start.count > 1 {
                        let indexSet = IndexSet((range.start.section ... range.end.section))
                        isInsert ?  self?.insertSections(indexSet)  : self?.deleteSections(indexSet)
                    } else if (range.start.count < 2) {
                        let indexes = ((range.start.first ?? 0) ... (range.end.first ?? 0)).map {IndexPath(item: $0, section: 0)}
                        isInsert ? self?.insertItems(at: indexes) :  self?.deleteItems(at: indexes)
                    } else if range.start.section == range.end.section {
                        let indexes = (range.start.item ... range.end.item).map {IndexPath(item: $0, section: range.start.section)}
                        
                        isInsert ? self?.insertItems(at: indexes) : self?.deleteItems(at: indexes)
                        
                    } else {
                        let indexSet = IndexSet((range.start.section ... range.end.section))
                        
                        isInsert ? self?.insertSections(indexSet) : self?.deleteSections(indexSet)
                    }
                }
            }
            .do(onNext: {
                if ($0 == nil) { viewModel.dataHolder.commitEditing.accept(true)}
            })
            .buffer(bufferObservable.throttle(0.5, scheduler: MainScheduler.instance))
            .subscribe(onNext: {[weak self] actions in
                if actions.count == 0 { return }
                if actions.filter ({$0 == nil}).count > 0 {
                    self?.reloadData()
                    return
                }
                lockAnimation.accept(true)
                self?.performBatchUpdates({
                    actions.compactMap {$0}.forEach { $0() }
                }, completion: {
                    lockAnimation.accept(!$0)
                    
                })
            })
            
            .disposed(by: self.disposeBag)
        
        if (self.backgroundView != nil) {
            viewModel.isEmpty.asObservable().map {!$0}.bind(to: self.backgroundView!.rx.isHidden).disposed(by: self.disposeBag)
        }
    }
    
    /// Creates a UICollectionViewCell with matching viewModel at indexPath without adding to any view, and determine its size by keeping width fixed at provided value.
    
    public func autosizeItemAt(indexPath: IndexPath, constrainedToWidth width: Float) -> CGSize {
        guard let viewModel = viewModel as? ListViewModelType else {
            return .zero
        }
        guard let dataSource = viewModel.collectionViewDataSource as? ViewModelCollectionViewDataSource else {
            return .zero
        }
        return dataSource.autoSizeForItem(at: indexPath, width: width)
    }
    
    /// Creates a UICollectionViewCell with matching viewModel at indexPath without adding to any view, and determine its size by keeping height fixed at provided value.

    public func autosizeItemAt(indexPath: IndexPath, constrainedToHeight height: Float) -> CGSize {
        guard let viewModel = viewModel as? ListViewModelType else {
            return .zero
        }
        guard let dataSource = viewModel.collectionViewDataSource as? ViewModelCollectionViewDataSource else {
            return .zero
        }
        return dataSource.autoSizeForItem(at: indexPath, height: height)
    }
    /// Calculates a cell's width that, multiplied by itemsPerLine,  will fit collectionView's width minus insets and horizontal spacings
    public func autoWidthForItemAt(indexPath: IndexPath, itemsPerLine: Int = 1) -> CGFloat {
        guard let flow = self.collectionViewLayout as? UICollectionViewFlowLayout else {
            return self.frame.size.width
        }
        let flowDelegate = self.delegate as? UICollectionViewDelegateFlowLayout
        let insets =  flowDelegate?.responds(to: #selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:insetForSectionAt:))) == true ? flowDelegate!.collectionView!(self, layout: flow, insetForSectionAt: indexPath.section) : flow.sectionInset
        
        let spacing =  flowDelegate?.responds(to: #selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:minimumInteritemSpacingForSectionAt:))) == true ? flowDelegate!.collectionView!(self, layout: flow, minimumInteritemSpacingForSectionAt: indexPath.section) : flow.minimumInteritemSpacing
        
        let globalWidth = self.frame.size.width - insets.left - insets.right - self.contentInset.left - self.contentInset.right
        
        let singleWidth = (CGFloat(globalWidth) - (CGFloat(max(0, itemsPerLine - 1)) * spacing)) / CGFloat(max(itemsPerLine, 1))
        return singleWidth
    }
    /// Calculates a cell's height that, multiplied by itemsPerLine,  will fit collectionView's height minus insets and vertical spacings
    public func autoHeightForItemAt(indexPath: IndexPath, itemsPerLine: Int = 1) -> CGFloat {
        guard let flow = self.collectionViewLayout as? UICollectionViewFlowLayout else {
            return self.frame.size.height
        }
        let flowDelegate = self.delegate as? UICollectionViewDelegateFlowLayout
        let insets =  flowDelegate?.responds(to: #selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:insetForSectionAt:))) == true ? flowDelegate!.collectionView!(self, layout: flow, insetForSectionAt: indexPath.section) : flow.sectionInset
        
        let spacing =  flowDelegate?.responds(to: #selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:minimumInteritemSpacingForSectionAt:))) == true ? flowDelegate!.collectionView!(self, layout: flow, minimumInteritemSpacingForSectionAt: indexPath.section) : flow.minimumInteritemSpacing
        
        let globalHeight = self.frame.size.height - insets.top - insets.bottom - self.contentInset.top - self.contentInset.bottom
        
        let singleHeight = (CGFloat(globalHeight) - (CGFloat(max(0, itemsPerLine - 1)) * spacing)) / CGFloat(max(itemsPerLine, 1))
        return singleHeight
    }
        /// Creates a UICollectionViewCell with matching viewModel at indexPath without adding to any view, and determine its size by calculating a fixed width that will fit current insets and spacing so that `itemsPerLine` are able to fit remaining width, and height by inflating the cell with viewModel's contents
    public func autosizeItemConstrainedToWidth(at indexPath: IndexPath, itemsPerLine: Int = 1) -> CGSize {
        
        return self.autosizeItemAt(indexPath: indexPath, constrainedToWidth: floor(Float(self.autoWidthForItemAt(indexPath: indexPath, itemsPerLine: itemsPerLine))))
        
    }
    /// Creates a UICollectionViewCell with matching viewModel at indexPath without adding to any view, and determine its size by calculating a fixed height that will fit current insets and spacing so that `itemsPerLine` are able to fit remaining height, and width by inflating the cell with viewModel's contents
    public func autosizeItemConstrainedToHeight(at indexPath: IndexPath, itemsPerLine: Int = 1) -> CGSize {
        
        return self.autosizeItemAt(indexPath: indexPath, constrainedToHeight: floor(Float(self.autoHeightForItemAt(indexPath: indexPath, itemsPerLine: itemsPerLine))))
        
    }
    
    @available(*, deprecated, message: "use autosizeItemConstrainedToWidth instead")
    public func autosizeItemAt(indexPath: IndexPath, itemsPerLine: Int = 1) -> CGSize {
        
        return self.autosizeItemAt(indexPath: indexPath, constrainedToWidth: floor(Float(self.autoWidthForItemAt(indexPath: indexPath, itemsPerLine: itemsPerLine))))
        
    }
}

extension Observable {
    /// collects elements from the source sequence until the boundary sequence fires. Then it emits the elements as an array and begins collecting again.
    func buffer<U>(_ boundary: Observable<U>) -> Observable<[E]> {
        return Observable<[E]>.create { observer in
            var buffer: [E] = []
            let lock = NSRecursiveLock()
            let boundaryDisposable = boundary.subscribe { event in
                lock.lock(); defer { lock.unlock() }
                switch event {
                case .next:
                    observer.onNext(buffer)
                    buffer = []
                default:
                    break
                }
            }
            let disposable = self.subscribe { event in
                lock.lock(); defer { lock.unlock() }
                switch event {
                case .next(let element):
                    buffer.append(element)
                case .completed:
                    observer.onNext(buffer)
                    observer.onCompleted()
                case .error(let error):
                    observer.onError(error)
                    buffer = []
                }
            }
            return Disposables.create([disposable, boundaryDisposable])
        }
    }
}
