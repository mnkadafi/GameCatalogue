//
//  RawgServiceAPI.swift
//  GameCatalogue
//
//  Created by Mochamad Nurkhayal Kadafi on 09/07/20.
//  Copyright © 2020 Mochamad Nurkhayal Kadafi. All rights reserved.
//

import Foundation

class RawgServiceAPI{
    static let pageURL = "https://api.rawg.io/api/games?page_size="
    static let detailURL = "https://api.rawg.io/api/games/"
    
    static func getAllData(page_size: String, completion: @escaping(Error?,[GameResults]?) -> Void){
        URLSession.shared.dataTask(with: URL(string: "\(pageURL)\(page_size)")!, completionHandler: { (data,response,error) in
            if let error = error {
                completion(error, nil)
            } else if let data = data {
                print(data)
                do {
                    let decoder = JSONDecoder()
                    let searchResults = try decoder.decode(GamesModel.self, from: data)
                    completion(nil, searchResults.results)
                } catch {
                    print("decoding error: \(error.localizedDescription)")
                }
            }
        }).resume()
    }
    
    static func getDetailGames(id: Int, completion: @escaping(Error?,DetailGameModel?) -> Void){
        URLSession.shared.dataTask(with: URL(string: "\(detailURL)\(id)")!, completionHandler: { (data,response,error) in
            if let error = error {
                completion(error, nil)
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let resultData = try decoder.decode(DetailGameModel.self, from: data)
                    completion(nil, resultData)
                } catch {
                    print("decoding error: \(error.localizedDescription)")
                    print(error)
                }
            }
        }).resume()
    }
}
