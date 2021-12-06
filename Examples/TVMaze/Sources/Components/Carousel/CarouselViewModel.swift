//
//  ShowDetailsViewModel.swift
//  TVMaze
//
//  Created by Andrea De vito on 18/10/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Boomerang
import RxBoomerang
import RxRelay


class CarouselViewModel: RxListViewModel, WithElementSize {
    var elementSize: ElementSize = Size.fixed(height: 200)
    var disposeBag: DisposeBag = DisposeBag()
    let uniqueIdentifier: UniqueIdentifier = UUID()
    let layoutIdentifier: LayoutIdentifier = ComponentIdentifier.carousel
    let sectionsRelay: BehaviorRelay<[Section]> = BehaviorRelay(value: [])
//    private let show : Show
//    let useCase: DetailUseCase
//    let components : ComponentViewModelFactory
    let cells : ComponentFactory
    let callback : (ViewModel) -> Void
    

    
    init(sections : [Section], cells : ComponentFactory, callback : @escaping (ViewModel) -> Void){
        self.cells = cells
        self.callback = callback
        self.sections = sections
        
    }
    
    func reload() {
        
        
    }
    
    func elementSize(at indexPath: IndexPath, type: String?) -> ElementSize? {
        guard type == nil else {return nil}
        switch indexPath.section {
        case 0 :
            return Size.aspectRatio(9/16, itemsPerLine: 1)
        default: return Size.automatic()
        }
    }
    
    func sectionProperties(at index: Int) -> Size.SectionProperties {
        .init(insets: .init(top: 10, left: 10, bottom: 10, right: 10),
              lineSpacing: 10,
              itemSpacing: 10)
    }
    func selectItem(at indexPath: IndexPath) {
                if let viewModel = self[indexPath] {
                    callback(viewModel)
                }
            }
}
