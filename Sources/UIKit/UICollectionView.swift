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


extension UICollectionReusableView : EmbeddableView{
    
}

private class ViewModelCollectionViewDataSource : NSObject, UICollectionViewDataSource {
    weak var viewModel: ListViewModelType?
    init (viewModel: ListViewModelType) {
        super.init()
        self.viewModel = viewModel
        
    }
    @objc public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell  {
        let viewModel:ItemViewModelType? = self.viewModel?.viewModel(atIndex:indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel?.itemIdentifier.name ?? defaultListIdentifier, for: indexPath)
        
        
        (cell as? ViewModelBindableType)?.bind(to:viewModel)
        return cell
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count =  self.viewModel?.dataHolder.modelStructure.value.children?.count ?? 1
        return count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count =  self.viewModel?.dataHolder.modelStructure.value.children?[section].models?.count
        count =  count ?? self.viewModel?.dataHolder.modelStructure.value.models?.count
        return count ?? 0
    }
    
    @objc public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let model = self.viewModel?.dataHolder.modelStructure.value.sectionModelsAtIndexPath(indexPath)?[kind] ?? self.viewModel?.dataHolder.modelStructure.value.sectionModelAtIndexPath(indexPath){
            //let model = self.viewModel?.dataHolder.modelStructure.value.sectionModelAtIndexPath(indexPath)//self.viewModel?.dataHolder.models.value.children?[indexPath.section].sectionModel
            
            
            let viewModel =  (self.viewModel as? ListViewModelTypeSectionable)?.sectionItemViewModel(fromModel: model, withType:kind)
            if (viewModel != nil) {
                let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: viewModel!.itemIdentifier.name, for: indexPath)
                (cell as? ViewModelBindableType)?.bind(to:viewModel)
                return cell
            }
        }
        
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: EmptyReusableView.emptyReuseIdentifier, for: indexPath)
    }
    struct StaticCellParameters {
        var constraint:NSLayoutConstraint!
        var cell:UIView!
    }
    
    
    
    var staticCells = [String:StaticCellParameters]()
    
    func staticCellForSize (at indexPath:IndexPath , width:Float) -> UIView?{
        guard let viewModel = self.viewModel?.viewModel(atIndex:indexPath) else { return nil }
        guard let nib = self.viewModel?.identifier(atIndex:indexPath) else {
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
            parameters = StaticCellParameters(constraint: constraint, cell:cell)
            
        }
        
        parameters!.constraint?.constant = CGFloat(width)
        (parameters!.cell as? ViewModelBindableType)?.bind(to:viewModel)
        
        //        self.bindViewModelToCellAtIndexPath(parameters!.cell, indexPath: indexPath, forResize: true)
        var newCells = staticCells
        newCells[nib.name] = parameters
        
        self.staticCells = newCells
        return parameters?.cell
        
    }
    
    func staticCellForSize (at indexPath:IndexPath , height:Float) -> UIView?{
        guard let viewModel = self.viewModel?.viewModel(atIndex:indexPath) else { return nil }
        guard let nib = self.viewModel?.identifier(atIndex:indexPath) else {
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
            parameters = StaticCellParameters(constraint: constraint, cell:cell)
            
        }
        
        parameters!.constraint?.constant = CGFloat(height)
        (parameters!.cell as? ViewModelBindableType)?.bind(to:viewModel)
        //        self.bindViewModelToCellAtIndexPath(parameters!.cell, indexPath: indexPath, forResize: true)
        var newCells = staticCells
        newCells[nib.name] = parameters
        
        self.staticCells = newCells
        return parameters?.cell
        
    }
    
    func autoSizeForItem(at indexPath:IndexPath, width:Float) -> CGSize {
        let cell = self.staticCellForSize(at:indexPath, width: width) as? EmbeddableView
        cell?.customContentView.setNeedsLayout()
        cell?.customContentView.layoutIfNeeded()
        let size = cell?.customContentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize) ?? CGSize.zero
        return size
    }
    
    func autoSizeForItem(at indexPath:IndexPath, height:Float) -> CGSize {
        let cell = self.staticCellForSize(at:indexPath, height: height) as? EmbeddableView
        cell?.customContentView.setNeedsLayout()
        cell?.customContentView.layoutIfNeeded()
        let size = cell?.customContentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize) ?? CGSize.zero
        return size
    }
    
}
private struct AssociatedKeys {
    static var viewModel = "viewModel"
    static var disposeBag = "disposeBag"
    static var isPlaceholder = "isPlaceholder"
    static var collectionViewDataSource = "collectionViewDataSource"
}
public extension ListViewModelType  {
    
    var collectionViewDataSource:UICollectionViewDataSource? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.collectionViewDataSource) as? UICollectionViewDataSource}
        set { objc_setAssociatedObject(self, &AssociatedKeys.collectionViewDataSource, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
}

fileprivate class EmptyReusableView : UICollectionViewCell {
    fileprivate static let emptyReuseIdentifier = "_emptyReusableView"
}


open class ContentCollectionViewCell : UICollectionViewCell, ViewModelBindable {
    public var viewModel: ViewModelType?
    public var disposeBag: DisposeBag = DisposeBag()
    weak var internalView:UIView?
    public var insetConstraints: [NSLayoutConstraint] = []
    
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


extension UICollectionView : ViewModelBindable {
    
    public var viewModel: ViewModelType? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.viewModel) as? ViewModelType}
        set { objc_setAssociatedObject(self, &AssociatedKeys.viewModel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
    
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
    
    public func bind(to viewModel: ViewModelType?) {
        guard let viewModel = viewModel as? ListViewModelType else {
            self.viewModel = nil
            return
        }
        self.viewModel = viewModel
        
        
        viewModel.listIdentifiers
            .forEach {[weak self] ( value) in
                if value.isEmbeddable {
                    self?.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: value.name)
                }
                else {
                    self?.register(UINib(nibName: value.name, bundle: nil), forCellWithReuseIdentifier: value.name)
                }
                
        }
        (viewModel as? ListViewModelTypeSectionable)?.sectionIdentifiers.forEach {[weak self] ( value) in
            if value.isEmbeddable {
                self?.register(ContentCollectionViewCell.self, forSupplementaryViewOfKind: value.type?.name ?? UICollectionElementKindSectionHeader, withReuseIdentifier: value.name)
            }
            else {
                self?.register(UINib(nibName: value.name, bundle: nil), forSupplementaryViewOfKind: value.type?.name ?? UICollectionElementKindSectionHeader, withReuseIdentifier: value.name)
            }
        }
        
        self.register(EmptyReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader , withReuseIdentifier: EmptyReusableView.emptyReuseIdentifier)
        self.register(EmptyReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionFooter , withReuseIdentifier: EmptyReusableView.emptyReuseIdentifier)
        if (viewModel.collectionViewDataSource == nil) {
            viewModel.collectionViewDataSource = ViewModelCollectionViewDataSource(viewModel: viewModel)
        }
        self.dataSource = viewModel.collectionViewDataSource
        
        viewModel
            .dataHolder
            .reloadAction
            .elements
            .subscribe(onNext:{[weak self] _ in self?.reloadData() })
            .addDisposableTo(self.disposeBag)
        
        if (self.backgroundView != nil) {
            viewModel.isEmpty.asObservable().map{!$0}.bind(to: self.backgroundView!.rx.isHidden).addDisposableTo(self.disposeBag)
        }
    }
    public func autosizeItemAt(indexPath:IndexPath, constrainedToWidth width:Float) -> CGSize {
        guard let viewModel = viewModel as? ListViewModelType else {
            return .zero
        }
        guard let dataSource = viewModel.collectionViewDataSource as? ViewModelCollectionViewDataSource else {
            return .zero
        }
        return dataSource.autoSizeForItem(at:indexPath, width: width)
    }
    
    public func autosizeItemAt(indexPath:IndexPath, constrainedToHeight height:Float) -> CGSize {
        guard let viewModel = viewModel as? ListViewModelType else {
            return .zero
        }
        guard let dataSource = viewModel.collectionViewDataSource as? ViewModelCollectionViewDataSource else {
            return .zero
        }
        return dataSource.autoSizeForItem(at:indexPath, height: height)
    }
    
    public func autoWidthForItemAt(indexPath:IndexPath, itemsPerLine:Int = 1) -> CGFloat {
        guard let flow = self.collectionViewLayout as? UICollectionViewFlowLayout else {
            return self.frame.size.width
          //  return self.autosizeItemAt(indexPath: indexPath, constrainedToWidth: Float(self.frame.size.width))
        }
        let flowDelegate = self.delegate as? UICollectionViewDelegateFlowLayout
        let insets =  flowDelegate?.responds(to:#selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:insetForSectionAt:))) == true ? flowDelegate!.collectionView!(self, layout: flow, insetForSectionAt: indexPath.section) : flow.sectionInset
        
        let spacing =  flowDelegate?.responds(to:#selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:minimumInteritemSpacingForSectionAt:))) == true ? flowDelegate!.collectionView!(self, layout: flow, minimumInteritemSpacingForSectionAt: indexPath.section) : flow.minimumInteritemSpacing
        
        
        let globalWidth = self.frame.size.width - insets.left - insets.right - self.contentInset.left - self.contentInset.right
        
        let singleWidth = (CGFloat(globalWidth) - (CGFloat(max(0,itemsPerLine - 1)) * spacing)) / CGFloat(max(itemsPerLine,1))
        return singleWidth
    }
    
    public func autoHeightForItemAt(indexPath:IndexPath, itemsPerLine:Int = 1) -> CGFloat {
        guard let flow = self.collectionViewLayout as? UICollectionViewFlowLayout else {
            return self.frame.size.height
            //  return self.autosizeItemAt(indexPath: indexPath, constrainedToWidth: Float(self.frame.size.width))
        }
        let flowDelegate = self.delegate as? UICollectionViewDelegateFlowLayout
        let insets =  flowDelegate?.responds(to:#selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:insetForSectionAt:))) == true ? flowDelegate!.collectionView!(self, layout: flow, insetForSectionAt: indexPath.section) : flow.sectionInset
        
        let spacing =  flowDelegate?.responds(to:#selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:minimumInteritemSpacingForSectionAt:))) == true ? flowDelegate!.collectionView!(self, layout: flow, minimumInteritemSpacingForSectionAt: indexPath.section) : flow.minimumInteritemSpacing
        
        
        let globalHeight = self.frame.size.height - insets.top - insets.bottom - self.contentInset.top - self.contentInset.bottom
        
        let singleHeight = (CGFloat(globalHeight) - (CGFloat(max(0,itemsPerLine - 1)) * spacing)) / CGFloat(max(itemsPerLine,1))
        return singleHeight
    }
    
    
    public func autosizeItemConstrainedToWidth(at indexPath:IndexPath, itemsPerLine:Int = 1) -> CGSize {
        
        return self.autosizeItemAt(indexPath: indexPath, constrainedToWidth: floor(Float(self.autoWidthForItemAt(indexPath: indexPath, itemsPerLine: itemsPerLine))))
        
    }
    
    public func autosizeItemConstrainedToHeight(at indexPath:IndexPath, itemsPerLine:Int = 1) -> CGSize {
        
        return self.autosizeItemAt(indexPath: indexPath, constrainedToHeight: floor(Float(self.autoHeightForItemAt(indexPath: indexPath, itemsPerLine: itemsPerLine))))
        
    }
    
    @available(*, deprecated, message: "use autosizeItemConstrainedToWidth instead")
    public func autosizeItemAt(indexPath:IndexPath, itemsPerLine:Int = 1) -> CGSize {
       
        return self.autosizeItemAt(indexPath: indexPath, constrainedToWidth: floor(Float(self.autoWidthForItemAt(indexPath: indexPath, itemsPerLine: itemsPerLine))))
        
    }
}
