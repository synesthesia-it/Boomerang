//
//  PageViewModelType.swift
//  Boomerang
//
//  Created by Stefano Mondino on 04/03/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift

public protocol PageViewModelType: SceneViewModelType {
    var pageTitle: Observable<String> { get }
    var selectedPageImage: Observable<Image> { get }
    var pageImage: Observable<Image> { get }
}

