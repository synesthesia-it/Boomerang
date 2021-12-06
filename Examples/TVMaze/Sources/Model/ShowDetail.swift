//
//  ShowDetail.swift
//  TVMaze
//
//  Created by Andrea De vito on 29/10/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Boomerang
import RxBoomerang
import RxRelay

struct ShowDetail{
    let show : Show
    let cast : [Cast]
    let seasons : [Season]
}


