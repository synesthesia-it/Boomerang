//
//  UIScrollView.swift
//  Boomerang
//
//  Created by Stefano Mondino on 02/07/17.
//
//

import UIKit
import RxSwift

extension ListIdentifier {
    var view:UIView? {
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

open class StackableScrollView : UIScrollView {
    public var direction:StackableScrollViewDirection = .vertical
    public var insets:UIEdgeInsets = .zero
    public var spacing:CGFloat = 0
    
    
    func install(viewModels:[ItemViewModelType]) {
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
            let lastView = viewModels.reduce(nil, { (lastView, viewModel) -> UIView? in
                if let view = viewModel.itemIdentifier.view, let bindable = view as? ViewModelBindableType {
                    container.addSubview(view)
                    view.addConstraintsToPinLeadingToSuperview(constant: insets.left)
                    view.addConstraintsToPinTrailingToSuperview(constant: insets.right)
                    if let lastView = lastView {
                        view.addConstraintsToPinTop(to: lastView, constant: space)
                    }
                    else {
                        view.addConstraintsToPinTopToSuperview(constant: insets.top)
                    }
                    bindable.bind(to: viewModel)
                    return view
                }
                return lastView
            })
            lastView?.addConstraintsToPinBottomToSuperview(constant: insets.bottom)
            return
        case .horizontal:
            container.addConstraintsToPinHeightToSuperview()
            let lastView = viewModels.reduce(nil, { (lastView, viewModel) -> UIView? in
                if let view = viewModel.itemIdentifier.view, let bindable = view as? ViewModelBindableType {
                    container.addSubview(view)
                    view.addConstraintsToPinTopToSuperview(constant: insets.top)
                    view.addConstraintsToPinBottomToSuperview(constant: insets.bottom)
                    if let lastView = lastView {
                        view.addConstraintsToPinLeft(to: lastView, constant: space)
                    }
                    else {
                        view.addConstraintsToPinLeadingToSuperview(constant: insets.left)
                    }
                    bindable.bind(to: viewModel)
                    return view
                }
                return lastView
            })
            lastView?.addConstraintsToPinTrailingToSuperview(constant: insets.right)
            return
            
        }
    }
}

extension StackableScrollView : ViewModelBindable {
    
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
            .reloadAction
            .elements
            .subscribe(onNext:{[weak self] structure in
                let viewModels = structure.indexPaths().flatMap { viewModel.viewModel(atIndex: $0)}
                self?.install(viewModels:viewModels)
                
            })
            .addDisposableTo(self.disposeBag)
        
        
    }
    
}
