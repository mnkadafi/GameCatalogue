//
//  StoreModel.swift
//  GameCatalogue
//
//  Created by Mochamad Nurkhayal Kadafi on 09/07/20.
//  Copyright © 2020 Mochamad Nurkhayal Kadafi. All rights reserved.
//

import Foundation

struct DeveloperModel : Codable {
    var results : [DeveloperElement]
}

struct DeveloperElement : Codable {
    var id : Int
    var name : String
    var games_count : Int
    var image_background : URL
}
