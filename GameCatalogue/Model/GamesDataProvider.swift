//
//  GamesDataProvider.swift
//  GameCatalogue
//
//  Created by Mochamad Nurkhayal Kadafi on 11/08/20.
//  Copyright © 2020 Mochamad Nurkhayal Kadafi. All rights reserved.
//

import CoreData
import UIKit

class GamesDataProvider{
    lazy var persistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GamesData")
        
        container.loadPersistentStores { (storeDescription, error) in
            guard error == nil else{
                fatalError("Unresolved error \(error!)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = false
        container.viewContext.undoManager = nil
        
        return container
    }()
    
    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }
    
    func getAllFavorite(completion : @escaping(_ favorite: [FavoriteGameModel]) -> ()){
        let taskContext = newTaskContext()
        
        taskContext.perform {
            let fetchRequest = NSFetchRequest<FavoriteGames>(entityName: "FavoriteGames")
            self.fetchDataFavorite(taskContext: taskContext, fetchRequest: fetchRequest) { (favorites) in
                completion(favorites)
            }
        }
    }
    
    func addFavorite(_ game: DetailGameModel, completion: @escaping() -> ()){
        let taskContext = newTaskContext()
        
        taskContext.performAndWait {
            
            if let entity = NSEntityDescription.entity(forEntityName: "FavoriteGames", in: taskContext) {
                let favorite = NSManagedObject(entity: entity, insertInto: taskContext)
                favorite.setValue(game.id, forKeyPath: "id")
                favorite.setValue(game.name_original, forKeyPath: "name_original")
                favorite.setValue(game.description, forKeyPath: "description_game")
                favorite.setValue(game.metacritic, forKeyPath: "metacritic")
                favorite.setValue(game.released, forKeyPath: "released")
                do{
                    if let imageURL = game.background_image {
                        let imageDL = try? Data.init(contentsOf: imageURL)
                        favorite.setValue(imageDL! as Data, forKeyPath: "background_image")
                    }else{
                        let imageNDL = UIImage.init(named: "no_image.png")
                        let dataImage = (imageNDL?.pngData()!)! as NSData
                        
                        favorite.setValue(dataImage as Data, forKeyPath: "background_image")
                    }
                }
                favorite.setValue("\(String(describing: game.website!))", forKeyPath: "website")
                favorite.setValue(game.rating, forKeyPath: "rating")
                
                for platform in game.platforms! as [DetailPlatform] {
                    let platformEntity = NSEntityDescription.entity(forEntityName: "Platforms", in: taskContext)
                    let platforms = NSManagedObject(entity: platformEntity!, insertInto: taskContext)
                    platforms.setValue(platform.platform.id, forKey: "id")
                    platforms.setValue(platform.platform.name, forKey: "name")
                    platforms.setValue(favorite, forKey: "favoritegames")
                }
                
                for developer in game.developers! as [DetailDeveloper] {
                    let developerEntity = NSEntityDescription.entity(forEntityName: "Developers", in: taskContext)
                    let developers = NSManagedObject(entity: developerEntity!, insertInto: taskContext)
                    developers.setValue(developer.id, forKey: "id")
                    developers.setValue(developer.name, forKey: "name")
                    developers.setValue(favorite, forKey: "favoritegames")
                }
                
                for genre in game.genres! as [DetailGenre] {
                    let genresEntity = NSEntityDescription.entity(forEntityName: "Genres", in: taskContext)
                    let genres = NSManagedObject(entity: genresEntity!, insertInto: taskContext)
                    genres.setValue(genre.id, forKey: "id")
                    genres.setValue(genre.name, forKey: "name")
                    genres.setValue(favorite, forKey: "favoritegames")
                }
                
                for publisher in game.publishers! as [DetailPublisher] {
                    let publisherEntity = NSEntityDescription.entity(forEntityName: "Publishers", in: taskContext)
                    let publishers = NSManagedObject(entity: publisherEntity!, insertInto: taskContext)
                    publishers.setValue(publisher.id, forKey: "id")
                    publishers.setValue(publisher.name, forKey: "name")
                    publishers.setValue(favorite, forKey: "favoritegames")
                }
            }
            
            do {
                try taskContext.save()
                completion()
            } catch let error as NSError {
                print("Error : \(error)")
            }
        }
    }
    
    func cekFavorite(_ id: Int, completion: @escaping(_ : Bool) -> ()){
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteGames")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            do{
                if let _ = try taskContext.fetch(fetchRequest).first{
                    let status = true
                    completion(status)
                }else{
                    let status = false
                    completion(status)
                }
            }catch let error as NSError{
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func searchByTitle(_ title: String, completion: @escaping(_ favorite: [FavoriteGameModel]) -> ()){
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<FavoriteGames>(entityName: "FavoriteGames")
            fetchRequest.predicate = NSPredicate(format: "name_original CONTAINS[c] %@", title)
            self.fetchDataFavorite(taskContext: taskContext, fetchRequest: fetchRequest) { (favorites) in
                completion(favorites)
            }
        }
    }
    
    func fetchDataFavorite(taskContext: NSManagedObjectContext, fetchRequest: NSFetchRequest<FavoriteGames>, completion: @escaping(_ favorite: [FavoriteGameModel]) -> ()){
        do{
            let results = try taskContext.fetch(fetchRequest)
            var favorites = [FavoriteGameModel]()
            var genres = [FDetailGenre]()
            var platforms = [FDetailPlatform]()
            var developers = [FDetailDeveloper]()
            var publishers = [FDetailPublisher]()
            
            for result in results{
                
                if let dataplatform = result.relplatforms?.allObjects{
                    for platform in dataplatform as! [Platforms]{
                        platforms.append(FDetailPlatform(id: Int(platform.id), name: platform.name!))
                    }
                }
                
                if let datadeveloper = result.reldevelopers?.allObjects{
                    for developer in datadeveloper as! [Developers]{
                        developers.append(FDetailDeveloper(id: Int(developer.id), name: developer.name!))
                    }
                }
                
                if let datagenres = result.relgenres?.allObjects{
                    for genre in datagenres as! [Genres]{
                        genres.append(FDetailGenre(id: Int(genre.id), name: genre.name!))
                    }
                }
                
                if let datapublisher = result.relpublishers?.allObjects{
                    for publisher in datapublisher as! [Publishers]{
                        publishers.append(FDetailPublisher(id: Int(publisher.id), name: publisher.name!))
                    }
                }
                
                let favoriteData = FavoriteGameModel(id: result.value(forKey: "id") as? Int, name_original: result.value(forKey: "name_original") as? String, description: result.value(forKey: "description_game") as? String, metacritic: result.value(forKey: "metacritic") as? Int, released: result.value(forKey: "released") as? String, background_image: result.value(forKey: "background_image") as? Data, website: result.value(forKey: "website") as? String, rating: result.value(forKey: "rating") as? Double, platforms: platforms, developers: developers, genres: genres, publishers: publishers)
                
                favorites.append(favoriteData)
            }
            
            completion(favorites)
        }catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func removeFavorite(_ id: Int, completion: @escaping() -> ()){
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteGames")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult,
                batchDeleteResult.result != nil {
                completion()
            }
        }
    }
    
    func deleteAllMember(completion: @escaping() -> ()) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteGames")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult,
                batchDeleteResult.result != nil {
                completion()
            }
        }
    }
}
