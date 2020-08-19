//
//  FavoriteModel.swift
//  GameCatalogue
//
//  Created by Mochamad Nurkhayal Kadafi on 12/08/20.
//  Copyright © 2020 Mochamad Nurkhayal Kadafi. All rights reserved.
//

import Foundation

struct FavoriteGameModel : Codable {
    var id : Int?
    var name_original : String?
    var description : String?
    var metacritic : Int?
    var released : String?
    var background_image : Data?
    var website : String?
    var rating : String?
    var platforms : [FDetailPlatform]?
    var developers : [FDetailDeveloper]?
    var genres : [FDetailGenre]?
    var publishers : [FDetailPublisher]?
}

struct FDetailPlatform : Codable{
    var platform : FDetailPlatformElement
}

struct FDetailPlatformElement : Codable {
    var id : Int
    var name : String
}

struct FDetailDeveloper: Codable {
    var id : Int
    var name : String
}

struct FDetailGenre : Codable {
    var id : Int
    var name : String
}

struct FDetailPublisher : Codable{
    var id : Int
    var name : String
}
