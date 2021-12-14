//
//  GameScreenViewModel.swift
//  GameOfFifteen_iOS
//
//  Created by Stefano Mondino on 05/12/21.
//

import Foundation
import Boomerang
import RxBoomerang
import RxRelay
import RxSwift
import UIKit

class StateGameScreenViewModel: RxListViewModel, RxNavigationViewModel {

    enum Layout: String, LayoutIdentifier {
        case gameScreen
    }

    var sectionsRelay: BehaviorRelay<[Section]> = .init(value: [])

    var disposeBag: DisposeBag = DisposeBag()

    let uniqueIdentifier: UniqueIdentifier = UUID()

    var layoutIdentifier: LayoutIdentifier = Layout.gameScreen
    private var reloadDisposeBag = DisposeBag()

    var count: Observable<Int> {
        stateMachine.state.map(\.count)
    }
    func update(count: Int) {
        stateMachine.send(.reset(lines: count))
    }
    let stateMachine: StateMachine
    let routes: PublishRelay<Route> = .init()
    init() {

        stateMachine = StateMachine()
        reload()
    }
    var title: Observable<String> {
        stateMachine.state.map{
            "Moves: \($0.game.steps)"
        }
    }
    
    func reload() {
        reloadDisposeBag = DisposeBag()
        let stateMachine = self.stateMachine
        stateMachine.state
            .asObservable()
            .map(\.game.elements)
            .distinctUntilChanged()
            .map { $0.map { GameItemViewModel(tile: $0) } }
            .map { [Section(id: "game", items: $0)] }
            .catchAndReturn([])
            .bind(to: sectionsRelay)
            .disposed(by: reloadDisposeBag)

        stateMachine.state
            .map(\.isWinning)
            .compactMap { $0 ? AlertRoute(title: "WOW!",
                                          message: "YOU WON!",
                                          actions: [.init(title: "OK",
                                                          callback: {
                stateMachine.send(.reset(lines: stateMachine.state.value.count))
            })]) : nil}

            .bind(to: routes)
            .disposed(by: reloadDisposeBag)
    }
    
    func changeDeck() {
        onNavigation(AlertRoute(title: "ChangeDeck",
                                message: "ChangeDeck",
                                actions: Game.Deck.allCases
                                    .map{deck in
                                    .init(title: deck.name, callback: {
                                        [weak self] in
                                        self?.stateMachine.send(.choose(deck: deck))
                                    })
        } 
                                
//                                    [.init(title: "OK",
//                                                callback: { [weak self] in
//            self?.stateMachine.send(.choose(deck: Game.Deck.alphabet))
//        })]
                                
                               )
        )
    }
        

    func selectItem(at indexPath: IndexPath) {
        self.stateMachine.send(.move(index: indexPath.item))
    }

    func elementSize(at indexPath: IndexPath, type: String?) -> ElementSize? {
        guard type == nil else { return nil }
        let count = CGFloat(stateMachine.state.value.count * 2)
        let sectionProperties = sectionProperties(at: indexPath.section)
        let columns = Int(floor(sqrt(count)))
        let rows = ceil(count/CGFloat(columns))
        return Size.custom(itemsPerLine: columns) { properties in
            let availableHeight = properties.containerBounds.height -
            (properties.containerInsets.top + properties.containerInsets.bottom + sectionProperties.insets.top + sectionProperties.insets.bottom + (rows - 1) * sectionProperties.lineSpacing )
           let height = availableHeight/CGFloat(rows)
            return CGSize(width: properties.maximumWidth ?? 0, height: height)
        }
    }

    func sectionProperties(at index: Int) -> Size.SectionProperties {
        .init(insets: .init(top: 5, left: 4, bottom: 5, right: 4),
              lineSpacing: 5,
              itemSpacing: 5)
    }
}
