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
    var released : String?
    var background_image : URL?
    var rating : Double?
    var platforms : [GamePlatforms]?
    var genres : [GenreElement]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case released
        case background_image
        case rating
        case platforms
        case genres
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        
        do{
            self.released = try container.decode(String.self, forKey: .released)
        }catch{
            self.released = "N/A"
        }
        do{
            self.background_image = try container.decode(URL.self, forKey: .background_image)
        }catch{
            self.background_image = nil
        }
        do{
            self.rating = try container.decode(Double.self, forKey: .rating)
        }catch{
            self.rating = 0.0
        }
        do{
            self.platforms = try container.decode([GamePlatforms].self, forKey: .platforms)
        }catch{
            self.platforms = []
        }
        
        do{
            self.genres = try container.decode([GenreElement].self, forKey: .genres)
        }catch{
            self.genres = []
        }
    }
}

struct GamePlatforms : Codable{
    var platform : PlatformElement
}

struct PlatformElement : Codable{
    var id : Int?
    var name : String?
}

struct GenreElement : Codable {
    var id : Int
    var name : String
}
