//
//  ScheduleUseCase.swift
//  TVMaze
//
//  Created by Andrea De vito on 08/10/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Boomerang
import RxBoomerang
import RxRelay

internal protocol ScheduleUseCase {
    func schedule() -> Observable<[Episode]>
}

public class ScheduleUseCaseImplementation: ScheduleUseCase {
    
    let repository : TVMazeRepository
  
    init(repository : TVMazeRepository){
        self.repository = repository
    }
    
    func schedule() -> Observable<[Episode]> {
        return repository.schedule()
    }
}

