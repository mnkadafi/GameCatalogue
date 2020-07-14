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
    var description : String?
    var metacritic : Int?
    var released : String?
    var background_image : URL?
    var website : URL?
    var rating : Double?
    var platforms : [DetailPlatform]?
    var developers : [DetailDeveloper]?
    var genres : [DetailGenre]?
    var publishers : [DetailPublisher]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name_original
        case description
        case metacritic
        case released
        case background_image
        case website
        case rating
        case platforms
        case developers
        case genres
        case publishers
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name_original = try container.decode(String.self, forKey: .name_original)

        do{
            self.description = try container.decode(String.self, forKey: .description)
        }catch{
            self.description = "N/A"
        }
        
        do{
            self.metacritic = try container.decode(Int.self, forKey: .metacritic)
        }catch{
            self.metacritic = 0
        }
        
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
            self.website = try container.decode(URL.self, forKey: .website)
        }catch{
            self.website = URL(string: "N/A")
        }
        
        do{
            self.rating = try container.decode(Double.self, forKey: .rating)
        }catch{
            self.rating = 0.0
        }
        
        do{
            self.platforms = try container.decode([DetailPlatform].self, forKey: .platforms)
        }catch{
            self.platforms = []
        }
        
        do{
            self.developers = try container.decode([DetailDeveloper].self, forKey: .developers)
        }catch{
            self.developers = []
        }
        
        do{
            self.genres = try container.decode([DetailGenre].self, forKey: .genres)
        }catch{
            self.genres = []
        }
        
        do{
            self.publishers = try container.decode([DetailPublisher].self, forKey: .publishers)
        }catch{
            self.publishers = []
        }
    }
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
