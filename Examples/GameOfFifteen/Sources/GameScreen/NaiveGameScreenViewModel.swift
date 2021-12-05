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

class NaiveGameScreenViewModel: GameScreenViewModel {
    enum Layout: String, LayoutIdentifier {
        case gameScreen
    }

    var sectionsRelay: BehaviorRelay<[Section]> = .init(value: [])

    var disposeBag: DisposeBag = DisposeBag()

    let uniqueIdentifier: UniqueIdentifier = UUID()

    var layoutIdentifier: LayoutIdentifier = Layout.gameScreen

    private var countRelay = BehaviorRelay<Int>(value: 2)

    var count: Observable<Int> { countRelay.asObservable() }

    let routes: PublishRelay<Route> = .init()

    func update(count: Int) {
        countRelay.accept(count)
    }

    var title: Observable<String> {
        count.map { "Game of \($0 * $0 + 1)" }
    }

    init() {
        count.bind { [weak self] _ in self?.reload() }
        .disposed(by: disposeBag)
    }

    func reload() {
        let gameItems = (1..<(countRelay.value * countRelay.value)).map { GameItemViewModel(number: $0) }
        let empty = GameItemViewModel(number: nil)
        let items = (gameItems + [empty]).shuffled()
        self.sections = [Section(id: "game", items: items)]

    }

    func selectItem(at indexPath: IndexPath) {
        let count = self.countRelay.value
        guard var section = sections.first,
              var items = section.items as? [GameItemViewModel],
        items.count == count * count else {
            print("something's really wrong with items.")
            return
        }
        guard let newIndex = items.switchIndex(for: indexPath.item, lineCount: count) else {
            return
        }
        items.swapAt(newIndex, indexPath.item)
        if items.isWinning(lineCount: count) {
            onNavigation(AlertRoute(title: "WOW",
                                    message: "You Won! Congrats!",
                                    actions: [.init(title: "Restart",
                                                    callback: { [weak self] in self?.reload() })
                                             ]))
        }
        section.items = items
        self.sections = [section]
    }

    func elementSize(at indexPath: IndexPath, type: String?) -> ElementSize? {
        guard type == nil else { return nil }
        return Size.aspectRatio(1, itemsPerLine: countRelay.value)
    }

    func sectionProperties(at index: Int) -> Size.SectionProperties {
        .init(insets: .init(top: 20, left: 4, bottom: 4, right: 4),
              lineSpacing: 4,
              itemSpacing: 4)
    }
}

extension Array where Element: GameItemViewModel {
    func switchIndex(for index: Int, lineCount: Int) -> Int? {
        guard let emptyIndex = self.firstIndex(where: { $0.isEmpty }) else { return nil }
        // same column when distance is less or equal than elements on a row and module is same
        let sameColumn = ((abs(emptyIndex - index) <= lineCount) && ((emptyIndex % lineCount) == (index % lineCount)))
        let sameLine = (abs(emptyIndex - index) < 2 && (emptyIndex / lineCount) == (index / lineCount))
        return (sameColumn || sameLine) ? emptyIndex : nil
    }
    func isWinning(lineCount: Int) -> Bool {
        let tileCount = (lineCount * lineCount)
        return self.compactMap { $0.number } == (1 ..< tileCount).map { $0 }
    }
}
