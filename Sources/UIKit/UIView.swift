//
//  UIView.swift
//  Boomerang
//
//  Created by Stefano Mondino on 25/06/17.
//
//

import UIKit
import RxCocoa
import RxSwift

/// A view that can be embedded in cells (UICollectionViewCells or UITableViewCells).
public protocol EmbeddableView: class {
    /**
     Setting this flag identifies a view that is currently being used as a placeholder and will never be displayed.
     This is useful, in reusable cells, to identify a view that is used to determine the cell size before being displayed.
     Example:
     ```
     class MyView: UIView, EmbeddableView, ViewModelBindable {
        var viewModel: ItemViewModelType
        ... //IBOutlets definition
        func bind(to viewModel:ViewModelType) {
            guard let viewModel = viewModel as? MyViewModel else { return }
            self.someLabel.text = viewModel.myText //used to inflate the cell and determine its size
            if self.isPlaceholder { return }
            // avoid to download a remote image if cell is not displayed
            viewModel.someRemoteObservableImage.bind(to:someImageView.rx.image).disposed(by:disposeBag)
        }
     }
     ```
     */
    var isPlaceholder: Bool { get set }
    
    ///Actual container for inner view
    var customContentView: UIView { get }
}

private struct AssociatedKeys {
    static var viewModel = "viewModel"
    static var disposeBag = "disposeBag"
    static var isPlaceholder = "isPlaceholder"
    static var collectionViewDataSource = "collectionViewDataSource"
}

public extension EmbeddableView where Self: UIView {
    ///For UICollectionViewCells and UITableViewCells returns `contentView`, otherwise returns self
    var customContentView: UIView {
        switch self {
        case let v as UICollectionViewCell : return v.contentView
        case let v as UITableViewCell : return v.contentView
        default: return self
        }
      
    }
    ///Defaults to false
    public var isPlaceholder: Bool {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.isPlaceholder) as? Bool ?? false}
        set { objc_setAssociatedObject(self, &AssociatedKeys.isPlaceholder, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
}
