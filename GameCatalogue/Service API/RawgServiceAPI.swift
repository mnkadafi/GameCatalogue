//
//  RawgServiceAPI.swift
//  GameCatalogue
//
//  Created by Mochamad Nurkhayal Kadafi on 09/07/20.
//  Copyright © 2020 Mochamad Nurkhayal Kadafi. All rights reserved.
//

import Foundation

class RawgServiceAPI{
    static let gamesURL = "https://api.rawg.io/api/games?page_size="
    static let detailURL = "https://api.rawg.io/api/games/"
    static let developersURL = "https://api.rawg.io/api/developers?page_size="
    static let session = URLSession.shared
    
    static func getAllData(page_size: Int, completion: @escaping(Error?,[GameResults]?) -> Void){
        session.dataTask(with: URL(string: "\(gamesURL)\(page_size)")!, completionHandler: { (data,response,error) in
            if let error = error {
                completion(error, nil)
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let searchResults = try decoder.decode(GamesModel.self, from: data)
                    completion(nil, searchResults.results)
                } catch {
                    print("Decoding error: \(error)")
                }
            }
        }).resume()
    }
    
    static func getDetailGames(id: Int, completion: @escaping(Error?,DetailGameModel?) -> Void){
        session.dataTask(with: URL(string: "\(detailURL)\(id)")!, completionHandler: { (data,response,error) in
            if let error = error {
                completion(error, nil)
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let resultData = try decoder.decode(DetailGameModel.self, from: data)
                    completion(nil, resultData)
                } catch {
                    print("Decoding error: \(error)")
                }
            }
        }).resume()
    }
    
    static func getAllDevelopers(page_size : Int, completion : @escaping(Error?, [DeveloperElement]?) -> Void){
        session.dataTask(with: URL(string: "\(developersURL)\(page_size)")!, completionHandler: { (data, response, error) in
            if let error = error {
                completion(error, nil)
            }else if let data = data {
                do{
                    let decoder = JSONDecoder()
                    let resultData = try decoder.decode(DeveloperModel.self, from: data)
                    completion(nil, resultData.results)
                }catch{
                    print("Decoding error: \(error)")
                }
            }
            }).resume()
    }
}
