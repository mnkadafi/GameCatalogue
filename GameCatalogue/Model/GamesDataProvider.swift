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
    
    func getAllMember(completion : @escaping(_ members: [FavoriteGameModel]) -> ()){
        let taskContext = newTaskContext()
        
        taskContext.perform {
            let fetchRequest = NSFetchRequest<FavoriteGames>(entityName: "FavoriteGames")
            do{
                let results = try taskContext.fetch(fetchRequest)
                var favorites : [FavoriteGameModel] = []
                var genres = [FDetailGenre]()
                var platformsElement = [FDetailPlatformElement]()
                let platforms = [FDetailPlatform]()
                var developers = [FDetailDeveloper]()
                var publishers = [FDetailPublisher]()
                
                for result in results{
                    
                    if let dataplatform = result.relplatforms?.allObjects{
                        for platform in dataplatform as! [Platforms]{
                            platformsElement.append(FDetailPlatformElement(id: Int(platform.id), name: platform.name!))
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
                    
                    let favoriteData = FavoriteGameModel(id: result.value(forKey: "id") as? Int, name_original: result.value(forKey: "name_original") as? String, description: result.value(forKey: "description_game") as? String, metacritic: result.value(forKey: "metacritic") as? String, released: result.value(forKey: "released") as? String, background_image: result.value(forKey: "background_image") as? Data, website: result.value(forKey: "website") as? String, rating: result.value(forKey: "rating") as? String, platforms: platforms, developers: developers, genres: genres, publishers: publishers)
                    
                    favorites.append(favoriteData)
                }
                completion(favorites)
            }catch let error as NSError{
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func addFavorite(_ id: Int, _ name_original: String, _ description_game: String, _ metacritic: String, _ released: String, _ background_image: Data, _ website: String, _ rating: String, listGenre: [DetailGenre], listPlatform: [DetailPlatform], listDeveloper: [DetailDeveloper], listPublisher: [DetailPublisher], completion: @escaping() -> ()){
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            
            if let entity = NSEntityDescription.entity(forEntityName: "FavoriteGames", in: taskContext) {
                let favorite = NSManagedObject(entity: entity, insertInto: taskContext)
                favorite.setValue(id, forKeyPath: "id")
                favorite.setValue(name_original, forKeyPath: "name_original")
                favorite.setValue(description_game, forKeyPath: "description_game")
                favorite.setValue(metacritic, forKeyPath: "metacritic")
                favorite.setValue(released, forKeyPath: "released")
                favorite.setValue(background_image, forKeyPath: "background_image")
                favorite.setValue(website, forKeyPath: "website")
                favorite.setValue(rating, forKeyPath: "rating")
                
                for platform in listPlatform {
                    let platformEntity = NSEntityDescription.entity(forEntityName: "Platforms", in: taskContext)
                    let platforms = NSManagedObject(entity: platformEntity!, insertInto: taskContext)
                    platforms.setValue(platform.platform.id, forKey: "id")
                    platforms.setValue(platform.platform.name, forKey: "name")
                    platforms.setValue(favorite, forKey: "favoritegames")
                }
                
                for developer in listDeveloper {
                    let developerEntity = NSEntityDescription.entity(forEntityName: "Developers", in: taskContext)
                    let developers = NSManagedObject(entity: developerEntity!, insertInto: taskContext)
                    developers.setValue(developer.id, forKey: "id")
                    developers.setValue(developer.name, forKey: "name")
                    developers.setValue(favorite, forKey: "favoritegames")
                }
                
                for genre in listGenre {
                    let genresEntity = NSEntityDescription.entity(forEntityName: "Genres", in: taskContext)
                    let genres = NSManagedObject(entity: genresEntity!, insertInto: taskContext)
                    genres.setValue(genre.id, forKey: "id")
                    genres.setValue(genre.name, forKey: "name")
                    genres.setValue(favorite, forKey: "favoritegames")
                }
                
                for publisher in listPublisher {
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
