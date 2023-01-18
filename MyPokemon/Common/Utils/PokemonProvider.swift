//
//  PokemonProvider.swift
//  MyPokemon
//
//  Created by Sigit on 18/01/23.
//

import Foundation
import CoreData

class PokemonProvider {
    public static let shared = PokemonProvider()
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyPokemon")
        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Unresolved error \(error!)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = false
        container.viewContext.undoManager = nil
        
        return container
    }()
    
    func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }

    // MARK: - Core Data Saving support
    func saveContext(backgroundContext: NSManagedObjectContext?, completion: (() -> Void)) {
        guard let context = backgroundContext else { return }
        guard context.hasChanges else { return }
        do {
            try context.save()
            completion()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
    
    
    func insertNewPokemon(id: Int, username: String, name: String, image: String, isSuccess: @escaping (Result<Bool, DatabaseError>) -> Void) {
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            if let entity = NSEntityDescription.entity(forEntityName: "MyPokemon", in: taskContext) {
                let myPokemon = NSManagedObject(entity: entity, insertInto: taskContext)
                checkDuplicate(id: id) { isDuplicate in
                    guard !isDuplicate else {
                        isSuccess(.failure(DatabaseError.duplicateData))
                        return
                    }
                    
                    myPokemon.setValue(id, forKey: "id")
                    myPokemon.setValue(name, forKey: "name")
                    myPokemon.setValue(username, forKey: "username")
                    myPokemon.setValue(image, forKey: "image")
                    
                    self.saveContext(backgroundContext: taskContext) {
                        isSuccess(.success(true))
                    }
                }
            } else {
                isSuccess(.failure(DatabaseError.requestFailed))
            }
        }
    }
    
    func checkDuplicate(id: Int, isDuplicate: @escaping (Bool) -> Void) {
        let taskContext = newTaskContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MyPokemon")
        let sort = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        taskContext.perform {
            do {
                let results = try taskContext.fetch(fetchRequest)
                let allPokemonID = results.map { $0.value(forKey: "id") as? Int }
                if allPokemonID.contains(where: { $0 == id}) {
                    isDuplicate(true)
                } else {
                    isDuplicate(false)
                }
            } catch {
                print("Couldn't fetch 'Transaction' \(error.localizedDescription)")
            }
        }
    }
    
    func getPokemonsLocale(completion: @escaping (Result<[FavoritePokemonModel], DatabaseError>) -> Void) {
        let taskContext = newTaskContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MyPokemon")
        let sort = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        taskContext.perform {
            do {
                let results = try taskContext.fetch(fetchRequest)
                var favorites = [FavoritePokemonModel]()
                
                results.forEach { managedObject in
                    let data = FavoritePokemonModel(
                        id: managedObject.value(forKey: "id") as? Int,
                        username: managedObject.value(forKey: "username") as? String,
                        name: managedObject.value(forKey: "name") as? String,
                        image: managedObject.value(forKey: "image") as? String)
                    favorites.append(data)
                }
                
                completion(.success(favorites))
            } catch {
                print("Couldn't fetch 'Transaction' \(error.localizedDescription)")
                completion(.failure(DatabaseError.requestFailed))
            }
        }
    }
    
    func deletePokemon(_ idPokemon: Int, completion: @escaping (() -> Void)) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyPokemon")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(idPokemon)")
            
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
                if batchDeleteResult.result != nil {
                    completion()
                }
            }
            
        }
    }
    
}
