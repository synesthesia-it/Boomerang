//
//  MKMapView.swift
//  Boomerang
//
//  Created by Stefano Mondino on 02/07/17.
//
//

import Foundation
import MapKit
import RxSwift
import RxCocoa

private struct AssociatedKeys {
    static var viewModel = "viewModel"
    static var disposeBag = "disposeBag"
}

extension MKMapView : ViewModelBindable {
    
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
        
        viewModel
            .dataHolder
            .reloadAction
            .elements
            .subscribe(onNext:{ [weak self] modelStructure in
                 let annotations = modelStructure.indexPaths().flatMap { viewModel.viewModel(atIndex: $0) as? MKAnnotation}
                if let oldAnnotations = self?.annotations {
                    self?.removeAnnotations(oldAnnotations)
                }
                self?.showAnnotations(annotations, animated: true)
            })
            .disposed(by:self.disposeBag)
    }
    
}
