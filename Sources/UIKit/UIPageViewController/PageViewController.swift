//
//  File.swift
//  
//
//  Created by Stefano Mondino on 20/07/2020.
//

import Foundation
import UIKit

public protocol PageSceneFactory {
    func page(for viewModel: ViewModel) -> UIViewController
}
open class PageViewController: UIPageViewController {
    let viewModel: ListViewModel
    let pageFactory: PageSceneFactory
    var data: PageViewControllerDataSource?
    public init(viewModel: ListViewModel,
         pageFactory: PageSceneFactory) {
        self.viewModel = viewModel
        self.pageFactory = pageFactory
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        let dataSource = PageViewControllerDataSource(viewModel: viewModel, pageFactory: pageFactory)
        self.data = dataSource
        self.bind(to: viewModel, dataSource: dataSource)
    }
}

public extension UIPageViewController {
    func bind(to viewModel: ListViewModel, dataSource: PageViewControllerDataSource) {
        viewModel.onUpdate = { [weak self] in
            self?.dataSource = nil
            dataSource.reset()
            self?.dataSource = dataSource
            if let first = dataSource.first {
                self?.setViewControllers([first], direction: .forward, animated: true, completion: nil)
            }
        }
        viewModel.onUpdate()
//
    }
}
open class PageViewControllerDataSource: NSObject, UIPageViewControllerDataSource {
    private let viewModel: ListViewModel
    private let factory: PageSceneFactory

    private var cachedViewControllers: [Int:UIViewController] = [:]

    public init(viewModel: ListViewModel,
         pageFactory: PageSceneFactory) {
        self.viewModel = viewModel
        self.factory = pageFactory

    }
    public func reset() {
        self.cachedViewControllers = [:]
    }
    func index(of viewController: UIViewController) -> Int? {
        cachedViewControllers.first(where: { key, value in value == viewController})?.key
    }
    var first: UIViewController? {
        viewController(at: 0)
    }
    private var items: [ViewModel] {
        viewModel.sections.first?.items ?? []
    }

    private func viewController(at index: Int) -> UIViewController? {
        guard index >= 0 && index < items.count else { return nil }
        if let viewController = self.cachedViewControllers[index] {
            return viewController
        }
        guard let viewModel = items[safe: index] else {
            return nil
        }
        let viewController = factory.page(for: viewModel)
        cachedViewControllers[index] = viewController
        return viewController
    }
    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = index(of: viewController) else {
            return nil
        }

        return self.viewController(at: index + 1)
    }
    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = index(of: viewController) else {
            return nil
        }
        return self.viewController(at: index - 1)
    }
}

fileprivate extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
