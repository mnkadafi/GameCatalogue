//
//  GamesModel.swift
//  GameCatalogue
//
//  Created by Mochamad Nurkhayal Kadafi on 09/07/20.
//  Copyright © 2020 Mochamad Nurkhayal Kadafi. All rights reserved.
//

import Foundation

struct GamesModel: Codable {
    var results : [GameResults]
}

struct GameResults : Codable{
    var id : Int
    var name : String
    var released : String
    var background_image : URL
    var rating : Float
    var platforms : [GamePlatforms]
    var genres : [GenreElement]
}

struct GamePlatforms : Codable{
    var platform : PlatformElement
}

struct PlatformElement : Codable{
    var id : Int
    var name : String
}

struct GenreElement : Codable {
    var id : Int
    var name : String
}
