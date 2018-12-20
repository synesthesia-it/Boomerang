``` //
//  UIScrollView.swift
//  Boomerang
//
//  Created by Stefano Mondino on 02/07/17.
//
//

import UIKit
import RxSwift
import RxCocoa

extension ListIdentifier {
    var view: UIView? {
        return Bundle.main.loadNibNamed(self.name, owner: nil, options: nil)?.first as? UIView
    }
}
private struct AssociatedKeys {
    static var viewModel = "viewModel"
    static var disposeBag = "disposeBag"
}

public enum StackableScrollViewDirection {
    case horizontal
    case vertical
}

open class StackableScrollView: UIScrollView {
    public var direction: StackableScrollViewDirection = .vertical
    public var insets: UIEdgeInsets = .zero
    public var spacing: CGFloat = 0
    
    public var containerView: UIView {
        return self.subviews.first!
    }
    
    fileprivate var _touchedIndexPath = BehaviorRelay<IndexPath?>(value:nil)
    
    open func install(viewModels: [ViewModelPack]) {
        self.subviews.forEach { $0.removeFromSuperview()}
        let container = UIView()
        container.backgroundColor = .clear
        self.addSubview(container)
        container.addConstraintsToFillSuperview()
        let insets = self.insets
        let space = self.spacing
        switch direction {
        case .vertical :
            container.addConstraintsToPinWidthToSuperview()
            let lastView = viewModels.reduce(nil, { (lastView, pack) -> UIView? in
                let viewModel = pack.viewModel
                if let view = viewModel.itemIdentifier.view, let bindable = view as? ViewModelBindableType {
                    container.addSubview(view)
                    
                    view.addConstraintsToPinLeadingToSuperview(constant: insets.left)
                    view.addConstraintsToPinTrailingToSuperview(constant: insets.right)
                    if let lastView = lastView {
                        view.addConstraintsToPinTop(to: lastView, constant: space)
                    } else {
                        view.addConstraintsToPinTopToSuperview(constant: insets.top)
                    }
                    bindable.bind(to: viewModel)
                    view.rx.didTouch()
                        .bind {[weak self] _ in self?._touchedIndexPath.accept(pack.indexPath) }
                        .disposed(by:bindable.disposeBag)
                    return view
                }
                return lastView
            })
            lastView?.addConstraintsToPinBottomToSuperview(constant: insets.bottom)
            return
        case .horizontal:
            container.addConstraintsToPinHeightToSuperview()
            let lastView = viewModels.reduce(nil, { (lastView, pack) -> UIView? in
                let viewModel = pack.viewModel
                if let view = viewModel.itemIdentifier.view, let bindable = view as? ViewModelBindableType {
                    container.addSubview(view)
                    view.addConstraintsToPinTopToSuperview(constant: insets.top)
                    view.addConstraintsToPinBottomToSuperview(constant: insets.bottom)
                    if let lastView = lastView {
                        view.addConstraintsToPinLeft(to: lastView, constant: space)
                    } else {
                        view.addConstraintsToPinLeadingToSuperview(constant: insets.left)
                    }
                    bindable.bind(to: viewModel)
                    view.rx.didTouch()
                        .bind {[weak self] _ in self?._touchedIndexPath.accept(pack.indexPath) }
                        .disposed(by:bindable.disposeBag)
                    return view
                }
                return lastView
            })
            lastView?.addConstraintsToPinTrailingToSuperview(constant: insets.right)
            return
            
        }
    }
}
public typealias ViewModelPack = (viewModel:ItemViewModelType,indexPath: IndexPath)

extension StackableScrollView: ViewModelBindable {
    
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
            self.install(viewModels: [])
            return
        }
        self.viewModel = viewModel
        
        viewModel
            .dataHolder
            .newDataAvailable
            .map { _ in viewModel.dataHolder.modelStructure.value }
            .subscribe(onNext: {[weak self] structure in
                let viewModels: [ViewModelPack] = structure.indexPaths().compactMap {
                    if let vm = (viewModel.viewModel(atIndex: $0)) {
                        return (viewModel:vm, indexPath:$0)
                    }
                    return nil
                    
                }
                self?.install(viewModels: viewModels)
                
            })
            .disposed(by: self.disposeBag)
        
    }
    
}

extension Reactive where Base: UIView {
    func didTouch() -> Observable<()> {
        return methodInvoked(#selector(UIView.touchesEnded(_:with:))).map {_ in ()}
    }
}

public extension Reactive where Base: StackableScrollView {
    public var didSelectIndexPath: Driver<IndexPath> {
        return base._touchedIndexPath
            .skip(1)
            .asDriver(onErrorJustReturn: nil)
            .filter {$0 != nil}
            .map { $0!}
    }
}
```
