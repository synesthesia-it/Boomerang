//
//  ShowRepository.swift
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

class TVMazeRepository {
    let networkDownloader: NetworkDataSource
    
    init(networkDownloader: NetworkDataSource) {
        self.networkDownloader = networkDownloader
    }

    func cast(show: Show) -> Observable<[Cast]>{
        let details = URL(string: "https://api.tvmaze.com/shows/\(show.id)/cast")!
        return networkDownloader
            .codable(at: details, type: [Cast].self)
    }
    
    func season(show: Show) -> Observable<[Season]> {
            let details = URL(string: "https://api.tvmaze.com/shows/\(show.id)/seasons")!
            return networkDownloader
            .codable(at: details, type: [Season].self)
        }
    
    func schedule() -> Observable<[Episode]> {
         let schedule = URL(string: "https://api.tvmaze.com/schedule")!
         return networkDownloader.codable(at: schedule, type: [Episode].self)
    }
    
    func search(text : String) -> Observable<[Search]> {
        let search = URL(string: "https://api.tvmaze.com/search/shows?q=\(text)")!
        return networkDownloader.codable(at: search, type: [Search].self)
    }
    
    func seasonDetail(season: Season) -> Observable<[Episode]> {
        let season = URL(string: "https://api.tvmaze.com/seasons/\(season.id)/episodes")!
        return networkDownloader.codable(at: season, type: [Episode].self)
    }
    
 
    func castDetail(person: Person) -> Observable<[Credits]> {
        let cast = URL(string: "https://api.tvmaze.com/people/\(person.id)/castcredits?embed=show")!
        return networkDownloader.codable(at: cast, type: [Credits].self)
    }
    
    func actor(person: Person) -> Observable<Actor> {
        let actorDetail = URL(string: "https://api.tvmaze.com/people/\(person.id)")!
        return networkDownloader.codable(at: actorDetail, type: Actor.self)
    }
    
    func episodeDetail(show: Show) -> Observable<ShowDetail> {
        Observable.combineLatest(self.cast(show: show), self.season(show: show))
        { castlist, seasonlist in
            ShowDetail(show: show, cast: castlist, seasons: seasonlist)
            
        }
    }
    
    func actorDetail(person: Person) -> Observable<ActorDetail> {
        Observable.combineLatest(self.castDetail(person: person), self.actor(person: person))
        {  credits, detail in
            ActorDetail(person: person, actorInfo: detail, credits: credits)
            
        }
    }
}
