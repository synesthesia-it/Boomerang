//
//  SearchUseCase.swift
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

internal protocol SearchUseCase {
    func search(text : String) -> Observable<[Search]>
}

public class SearchUseCaseImplementation: SearchUseCase {
    
    let repository : TVMazeRepository
  
    init(repository : TVMazeRepository){
        self.repository = repository
    }
    
    
    func search(text : String) -> Observable<[Search]> {
        return repository.search(text: text)
    }
}


