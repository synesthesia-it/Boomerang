//
//  InteractionCompatible.swift
//  Boomerang
//
//  Created by Stefano Mondino on 05/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

public protocol InteractionCompatible: ViewModelCompatibleType {
    func setupInteraction(with viewModel: InteractionViewModelType)
    func handleInteraction(_ route: Route)
    func handleInteraction(_ custom: CustomInteraction)
    func handleInteraction(_ interaction: Interaction)
}
