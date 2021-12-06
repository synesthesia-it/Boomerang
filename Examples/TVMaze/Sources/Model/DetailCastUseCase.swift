//
//  DetailCastUseCase.swift
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

internal protocol DetailCastUseCase {
    func detail(person: Person) -> Observable<ActorDetail>
   
}

public class DetailCastUseCaseImplementation: DetailCastUseCase {
    func person(person: Person) -> Observable<ActorDetail> {
        return repository.actorDetail(person: person)
    }
    
   
    let repository: TVMazeRepository
    
    init(repository: TVMazeRepository) {
        self.repository = repository
    }
    
    
    
    func detail(person: Person) -> Observable<ActorDetail> {
        return repository.actorDetail(person: person)
    }
    
//    func actorDetail(person: Person) -> Ober
}


