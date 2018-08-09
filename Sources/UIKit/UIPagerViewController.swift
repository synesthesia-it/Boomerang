//
//  UICollectionView.swift
//  Boomerang
//
//  Created by Stefano Mondino on 02/11/16.
//
//

import UIKit
import RxSwift

/**
 Generic protocol used to handle pagers (usually horizontal collections of view controllers such as UIPageViewController).
 - Note:
 In MVVM, any view model should not have any reference to view-layer related components.
 However, due to UIPageViewController behavior and original design, we find reasonable to have a method, in the view model layer, that somehow retrieves and returns ViewControllers, as long as those components are not used elsewhere inside the view model itself.
 */
public protocol ListPagerViewModelType: ListViewModelType {
    ///The initial index to display when pager is reloaded
    var startingIndex: Int {get}
    /// The viewController matching provided identifier
    func viewController(fromIdentifier: ListIdentifier) -> UIViewController?
}
/// Concrete, objc compliant, implementation for UIPageViewControllerDataSource
public class ViewModelPagerViewDataSource: NSObject, UIPageViewControllerDataSource {
    weak var viewModel: ListPagerViewModelType?
    weak var pageViewController: UIPageViewController?
    var viewControllers: [Int: UIViewController] = [:]
    init (viewModel: ListPagerViewModelType) {
        super.init()
        self.viewModel = viewModel
        
    }
    /* 
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.viewModel?.dataHolder.modelStructure.value.models?.count ?? 0
    }
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let vc = pageViewController.viewControllers?.first else {
            return 0
        }
        return self.indexForViewController(vc)
    }*/
    func indexForViewController(_ viewController: UIViewController) -> Int {
        return self.viewControllers.first (where: { $1 == viewController })?.0 ?? 0
    }
    func reset() {
        self.viewControllers = [:]
    }
    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index: Int = self.indexForViewController(viewController)
        index -= 1
        if (index < 0) {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        guard let vc = viewControllers[index] else {
            
            guard let viewModel = self.viewModel?.viewModel(atIndex: IndexPath(row: index, section: 0)) else {
                return nil
            }
        
            guard let viewController = self.viewModel?.viewController(fromIdentifier: viewModel.itemIdentifier) else {
                return nil
                
            }
            
//            _ = viewController.view //triggers viewDidLoad before view model binding. Alternatives are really welcomed
            (viewController as? ViewModelBindableType)?.bind(to: viewModel)
            self.viewControllers[index] = viewController
            return viewController
        
        }
        return vc
    }
    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index: Int = self.indexForViewController(viewController)
        index += 1
        if (index >= (self.viewModel?.dataHolder.modelStructure.value.models?.count ?? 0) ) {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
}
private struct AssociatedKeys {
    static var viewModel = "viewModel"
    static var disposeBag = "disposeBag"
    static var pagerDataSource = "pagerDataSource"
}
private extension ListPagerViewModelType {
    
    var pagerDataSource: ViewModelPagerViewDataSource? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.pagerDataSource) as? ViewModelPagerViewDataSource}
        set { objc_setAssociatedObject(self, &AssociatedKeys.pagerDataSource, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
}

extension UIPageViewController: ViewModelBindable {
    /// Current viewModel. Property is retained.
    public var viewModel: ViewModelType? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.viewModel) as? ViewModelType}
        set { objc_setAssociatedObject(self, &AssociatedKeys.viewModel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
    /**
     A lazily-created disposeBag where disposables can be easily stored.
     */
    public var disposeBag: DisposeBag {
        var disposeBag: DisposeBag
        
        if let lookup = objc_getAssociatedObject(self, &AssociatedKeys.disposeBag) as? DisposeBag {
            disposeBag = lookup
        } else {
            disposeBag = DisposeBag()
            objc_setAssociatedObject(self, &AssociatedKeys.disposeBag, disposeBag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        return disposeBag
    }
    /// Current number of viewControllers inside the list
    public func presentationCount() -> Int {
        return (self.viewModel as? ListViewModelType)?.dataHolder.modelStructure.value.models?.count ?? 0
    }
    /// Current viewController index
    public func presentationIndex() -> Int {
        guard let vc = self.viewControllers?.first else {
            return 0
        }
        return (self.viewModel as? ListPagerViewModelType)?.pagerDataSource?.indexForViewController(vc) ?? 0
    }
    /// Binds current pager to a `ListPagerViewModelType`. If provided view model doesn't conform to that procol, previous view model is set to nil and nothing further happens.
    public func bind(to viewModel: ViewModelType?) {
        guard let viewModel = viewModel as? ListPagerViewModelType else {
            self.viewModel = nil
            return
        }
        self.viewModel = viewModel
        
        if (viewModel.pagerDataSource == nil) {
            viewModel.pagerDataSource = ViewModelPagerViewDataSource(viewModel: viewModel)
        }
        self.dataSource = viewModel.pagerDataSource
        viewModel.pagerDataSource?.pageViewController = self
        viewModel
            .dataHolder
            .reloadAction
            .elements
            .subscribe(onNext: {[weak self] _ in
                viewModel.pagerDataSource?.reset()
                self?.setViewControllers([viewModel.pagerDataSource?.viewControllerAtIndex(viewModel.startingIndex) ?? UIViewController()], direction: .forward, animated: false, completion: nil)
            })
            .disposed(by: self.disposeBag)
        viewModel.reload()
        
    }
}
