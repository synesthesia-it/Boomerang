//
//  PagerViewModel.swift
//  TVMaze
//
//  Created by Andrea De vito on 19/11/21.
//

import Boomerang
//import Core
import Foundation
import RxRelay
import RxSwift
import UIKit
import RxBoomerang

public protocol PageViewModel: ViewModel {
    var pageTitle: String { get }
    var pageIcon: UIImage? { get }
}


open class PagerViewModel: RxListViewModel, PageViewModel {
   
    public enum Layout: String, LayoutIdentifier {
       
        
        case tab
    }

    public var pageTitle: String = ""

    public var pageIcon: UIImage?

    public let sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])

    public var disposeBag = DisposeBag()

    public var layoutIdentifier: LayoutIdentifier

    public var uniqueIdentifier: UniqueIdentifier = UUID()
    public var isLoading: Observable<Bool> = .just(false)
    public var onUpdate = {}

    private let pages: Observable<[ViewModel]>

    public convenience init(pages: [ViewModel],
                            layout: Layout = .tab) {
        self.init(pages: .just(pages),
                  layout: layout)
    }

    public init(pages: Observable<[ViewModel]>,
                layout: Layout = .tab) {
        self.pages = pages
        layoutIdentifier = layout
    }

    open func reload() {
        disposeBag = DisposeBag()
        pages
            .map { [Section(items: $0)] }
            .bind(to: sectionsRelay)
            .disposed(by: disposeBag)
    }

    open func selectItem(at _: IndexPath) {}
}
