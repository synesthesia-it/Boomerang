//
//  Struct.swift
//  TVMaze
//
//  Created by Andrea De vito on 08/10/21.
//

import Foundation

struct Episode: Codable, CustomStringConvertible {
    var description: String {
        show?.name ?? name
    }
    
    let id: Int
    let url: URL
    let name: String
    let airdate: String?
    let type: String?
    let season: Int
    let number: Int?
    let summary : String?
    let show: Show?
    let image : Image?
}

struct Show: Codable {
    let id: Int
    let url: URL
    let name: String
    let type : String
    let language : String?
    let genres: [String]
    let status: String?
    let runtime: Int?
    let averageRuntime: Int?
    let premiered: String?
    let ended : String?
    let officialSite : String?
    let image : Image?
    let summary : String?
    let weight : Double?
}

struct Season: Codable{
    let id: Int
    let url: URL
    let number:Int
    let name: String?
    let episodeOrder: Int?
    let premiereDate: String?
    let endDate: String?
    let image : Image?
    
}

struct Cast: Codable {
    let person: Person
    internal init(person: Person) {
        self.person = person
    }
}

struct  Person: Codable {
    let id: Int
    let name: String
    let image: Image?
    
}

struct Actor: Codable {
    let id: Int
    let name: String
    let image: Image?
//    let country: Country? 
    let birthday: String?
    let deathday: String?
    let gender: String?
}

struct  Character: Codable {
    let id: Int
    let name: String
    let Image : Image
}

struct Country : Codable {
    let name: String
    let code: String
    let timezone: String
}


struct Credits : Codable {
  //  let character : URL
//    let _links : Link
    let _embedded : Embedded
}

struct Embedded : Codable {
    let show : Show
//    let weight : Int
    
}

struct Network : Codable{
    let id: Int
    let name: String
}

struct Link : Codable {
    let show : URL
    let character : URL
}

struct Image: Codable {
    internal init(medium: URL?, original: URL?) {
        self.medium = medium
        self.original = original
    }
    
    let medium: URL?
    let original: URL?
}

struct Search: Codable {
    let score: Double
    let show: Show
}



