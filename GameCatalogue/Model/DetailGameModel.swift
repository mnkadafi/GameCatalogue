//
//  DetailGameModel.swift
//  GameCatalogue
//
//  Created by Mochamad Nurkhayal Kadafi on 09/07/20.
//  Copyright © 2020 Mochamad Nurkhayal Kadafi. All rights reserved.
//

import Foundation

struct DetailGameModel : Codable {
    var id : Int
    var name_original : String
    var description : String
    var metacritic : Int
    var released : String
    var background_image : URL
    var website : URL
    var rating : Float
    var platforms : [DetailPlatform]
    var developers : [DetailDeveloper]
    var genres : [DetailGenre]
    var publishers : [DetailPublisher]
}

struct DetailPlatform : Codable{
    var platform : DetailPlatformElement
}

struct DetailPlatformElement : Codable {
    var id : Int
    var name : String
}

struct DetailDeveloper: Codable {
    var id : Int
    var name : String
}

struct DetailGenre : Codable {
    var id : Int
    var name : String
}

struct DetailPublisher : Codable{
    var id : Int
    var name : String
}
