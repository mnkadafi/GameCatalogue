//
//  RawgServiceAPI.swift
//  GameCatalogue
//
//  Created by Mochamad Nurkhayal Kadafi on 09/07/20.
//  Copyright © 2020 Mochamad Nurkhayal Kadafi. All rights reserved.
//

import Foundation

class RawgServiceAPI{
    static let baseURL = "https://api.rawg.io"
    static let gamesPathQuery = baseURL+"/api/games?page_size="
    static let searchPathQuery = baseURL+"/api/games?search="
    static let detailPathQuery = baseURL+"/api/games/"
    static let developerPathQuery = baseURL+"/api/developers"
    static let session = URLSession.shared
    
    static func getAllData(page_size: Int, completion: @escaping(Error?,[GameResults]?) -> Void){
        session.dataTask(with: URL(string: "\(gamesPathQuery)\(page_size)")!, completionHandler: { (data,response,error) in
            if let error = error {
                completion(error, nil)
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let gameResult = try decoder.decode(GamesModel.self, from: data)
                    completion(nil, gameResult.results)
                } catch {
                    print("Decoding error: \(error)")
                }
            }
        }).resume()
    }
    
    static func getDataByTitle(title: String, completion: @escaping(Error?, [GameResults]?) -> Void){
        session.dataTask(with: URL(string: "\(searchPathQuery)\(title)")!, completionHandler: { (data,response,error) in
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
        session.dataTask(with: URL(string: "\(detailPathQuery)\(id)")!, completionHandler: { (data,response,error) in
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
    
    static func getAllDevelopers(completion : @escaping(Error?, [DeveloperElement]?) -> Void){
        session.dataTask(with: URL(string: "\(developerPathQuery)")!, completionHandler: { (data, response, error) in
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
