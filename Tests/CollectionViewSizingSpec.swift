//
//  CollectionViewSizingSpec.swift
//  BoomerangTests
//
//  Created by Stefano Mondino on 26/01/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Quick
import Nimble
import UIKit
import RxSwift
@testable import Boomerang

class CollectionViewSizingSpec: QuickSpec {
    override func spec() {
        
        struct TestListViewModel: ListViewModel {
            typealias DataType = [String]
            var dataHolder: DataHolder = DataHolder()
            init() {
                dataHolder = DataHolder(data: group(.just((0..<5).map {"\($0)"})))
            }
            func convert(model: ModelType, at indexPath: IndexPath, for type: String?) -> IdentifiableViewModelType? {
                switch model {
                case let model as String : return TestItemViewModel(model: model)
                default: return nil
                }
            }
            
            func group(_ observable: Observable<[String]>) -> Observable<DataGroup> {
                return observable.map {
                    DataGroup($0)
                }
            }
        }
        var viewModel = TestListViewModel()
        var viewController = ViewController(nibName: nil, bundle: nil)
        let collectionWidth: CGFloat = 400.0
        let collectionHeight: CGFloat = 500.0
        let spacing:CGFloat = 10
        var collectionView: UICollectionView {
            return viewController.view as! UICollectionView
        }
        describe("When using automatic sizing features, a collection view") {
            context("when no flow delegate is specified, a collection view") {
                
                beforeEach {
                    
                    viewController = ViewController(nibName: nil, bundle: nil)
                    let window = UIWindow(frame: CGRect(x: 0, y: 0, width: collectionWidth, height: collectionHeight))
                    window.rootViewController = viewController
                    window.isHidden = false
                    viewModel = TestListViewModel()
                    collectionView.boomerang.configure(with: viewModel)
                    viewModel.delayedLoad()
                    (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing = spacing
                }
                
                it ("should properly calculate dimension for 1 item per line") {
                    expect(collectionView.boomerang.calculateFixedDimension(for: .horizontal, at: IndexPath(item: 0, section: 0), itemsPerLine: 1)) == collectionHeight
                    expect(collectionView.boomerang.calculateFixedDimension(for: .vertical, at: IndexPath(item: 0, section: 0), itemsPerLine: 1)) == collectionWidth
                    
                }
                it ("should properly calculate dimension for 3 items per line") {
                    expect(collectionView.boomerang.calculateFixedDimension(for: .horizontal, at: IndexPath(item: 0, section: 0), itemsPerLine: 3)) == (collectionHeight - 2 * spacing)/3
                    expect(collectionView.boomerang.calculateFixedDimension(for: .vertical, at: IndexPath(item: 0, section: 0), itemsPerLine: 3)) == (collectionWidth - 2 * spacing) / 3
                    
                }
            }
        }
    }
}
