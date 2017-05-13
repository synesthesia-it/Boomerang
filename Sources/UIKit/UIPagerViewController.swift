//
//  UICollectionView.swift
//  Boomerang
//
//  Created by Stefano Mondino on 02/11/16.
//
//


import UIKit
import RxSwift

public protocol ListPagerViewModelType : ListViewModelType {
    var startingIndex:Int {get}
    func viewController(fromIdentifier:ListIdentifier) -> UIViewController?
}

public class ViewModelPagerViewDataSource : NSObject, UIPageViewControllerDataSource {
    weak var viewModel: ListPagerViewModelType?
    weak var pageViewController: UIPageViewController?
    var viewControllers:[Int:UIViewController] = [:]
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
        return self.viewControllers.first (where:  { $1 == viewController })?.0 ?? 0
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
private extension ListPagerViewModelType  {
    
    var pagerDataSource:ViewModelPagerViewDataSource? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.pagerDataSource) as? ViewModelPagerViewDataSource}
        set { objc_setAssociatedObject(self, &AssociatedKeys.pagerDataSource, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
}

extension UIPageViewController : ViewModelBindable {
    
    public var viewModel: ViewModelType? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.viewModel) as? ViewModelType}
        set { objc_setAssociatedObject(self, &AssociatedKeys.viewModel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
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
    public func presentationCount() -> Int {
        return (self.viewModel as? ListViewModelType)?.dataHolder.modelStructure.value.models?.count ?? 0
    }
    public func presentationIndex() -> Int {
        guard let vc = self.viewControllers?.first else {
            return 0
        }
        return (self.viewModel as? ListPagerViewModelType)?.pagerDataSource?.indexForViewController(vc) ?? 0
    }
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
            .subscribe(onNext:{[weak self] _ in
                viewModel.pagerDataSource?.reset()
                self?.setViewControllers([viewModel.pagerDataSource?.viewControllerAtIndex(viewModel.startingIndex) ?? UIViewController()], direction: .forward, animated:false, completion: nil)
            })
            .addDisposableTo(self.disposeBag)
        viewModel.reload()
        
    }
}
