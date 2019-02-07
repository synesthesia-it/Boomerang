//
//  Interaction.swift
//  Boomerang
//
//  Created by Stefano Mondino on 05/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public typealias Selection = Action<Interaction,Interaction>

public enum Interaction {
    case none
    case restart
    case route(Route)
    case viewModel(ViewModelType)
    case selectItem(IndexPath)
    case custom(CustomInteraction)
}

public protocol CustomInteraction {}

public protocol InteractionViewModelType: ViewModelType {
    var selection: Selection { get }
    func defaultSelection() -> Selection
    func handleRestart() -> Observable<Interaction>
    func handleRoute(_ route: Route) -> Observable<Interaction>
    func handleViewModel(_ viewModel: ViewModelType) -> Observable<Interaction>
    func handleSelectItem(_ indexPath: IndexPath) -> Observable<Interaction>
    func handleCustom(_ interaction: CustomInteraction) -> Observable<Interaction>
}

extension InteractionViewModelType {
    public func defaultSelection() -> Selection {
        if let classSelf = self as? (AnyObject & InteractionViewModelType) {
            return Selection { [weak classSelf] in classSelf?.switch($0) ?? .empty()}
        }
        return Selection { self.switch($0) }
    }
    
    func `switch`(_ input: Interaction) -> Observable<Interaction> {
        switch input {
        case .restart: return self.handleRestart()
        case .route(let route): return self.handleRoute(route)
        case .viewModel(let viewModel): return self.handleViewModel(viewModel)
        case .selectItem(let indexPath): return self.handleSelectItem(indexPath)
        case .custom(let custom): return self.handleCustom(custom)
        case .none: return .empty()
        }
    }
    
    public func handleRestart() -> Observable<Interaction> {
        return .just(.restart)
    }
    public func handleRoute(_ route: Route) -> Observable<Interaction> {
        return .just(.route(route))
    }
    public func handleViewModel(_ viewModel: ViewModelType) -> Observable<Interaction> {
        return .just(.viewModel(viewModel))
    }
    public func handleSelectItem(_ indexPath: IndexPath) -> Observable<Interaction> {
        return .empty()
    }
    public func interact(_ input: Interaction) {
        self.selection.execute(input)
    }
}



