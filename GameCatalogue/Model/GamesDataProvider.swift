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
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteGames")
            do{
                let results = try taskContext.fetch(fetchRequest)
                var favorites : [FavoriteGameModel] = []
                for result in results{
                    let favoriteData = FavoriteGameModel(id: result.value(forKey: "id") as? Int, name_original: result.value(forKey: "name_original") as? String, description: result.value(forKey: "description_game") as? String, metacritic: result.value(forKey: "metacritic") as? String, released: result.value(forKey: "released") as? String, background_image: result.value(forKey: "background_image") as? Data, website: result.value(forKey: "website") as? String, rating: result.value(forKey: "rating") as? String)
                    favorites.append(favoriteData)
                }
                completion(favorites)
            }catch let error as NSError{
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func addFavorite(_ id: Int, _ name_original: String, _ description_game: String, _ metacritic: String, _ released: String, _ background_image: Data, _ website: String, _ rating: String, completion: @escaping() -> ()){
        let taskContext = newTaskContext()
        print("QW \(id)")
        taskContext.performAndWait {
            print("OA \(id)")
            if let entity = NSEntityDescription.entity(forEntityName: "FavoriteGames", in: taskContext) {
                let favorite = NSManagedObject(entity: entity, insertInto: taskContext)
                print("AW \(id)")
                favorite.setValue(id, forKeyPath: "id")
                favorite.setValue(name_original, forKeyPath: "name_original")
                favorite.setValue(description_game, forKeyPath: "description_game")
                favorite.setValue(metacritic, forKeyPath: "metacritic")
                favorite.setValue(released, forKeyPath: "released")
                favorite.setValue(background_image, forKeyPath: "background_image")
                favorite.setValue(website, forKeyPath: "website")
                favorite.setValue(rating, forKeyPath: "rating")
                
                do {
                    try taskContext.save()
                    completion()
                } catch let error as NSError {
                    print("Error : \(error)")
                }
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
}
