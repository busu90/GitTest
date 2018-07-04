//
//  LocalRepositoryProvider.swift
//  GitTest
//
//  Created by Andrei Busuioc on 7/1/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol LocalRepositoryProvider {
    func getFavorites() -> [Repository]
    func getFavorites(inList: [Repository]) -> [Repository]
    func saveToFavorites(repository: Repository) -> Bool
    func removeFavorites(repository: Repository) -> Bool
    func getContext() -> NSManagedObjectContext
}

public final class LocalRepositoryProviderInplementation:  LocalRepositoryProvider{
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getFavorites(inList: [Repository]) -> [Repository]{
        let fetchRequest: NSFetchRequest<RepositoryDOM> = RepositoryDOM.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(RepositoryDOM.stargazersCount), ascending: false)
        ]
        if inList.count > 0{
            let ids = inList.map { (repo) -> Int in
                return repo.id
            }
            fetchRequest.predicate = NSPredicate(format: "id IN %@", ids)
        }
        fetchRequest.includesPropertyValues=true
        fetchRequest.includesPendingChanges = true
        
        do {
            let result = try context.fetch(fetchRequest)
            return result.map({ (repoDOM) -> Repository in
                let repo = Repository(managedObject: repoDOM)
                repo.isFavorite = true
                return repo
            })
        } catch {
            return []
        }
    }
    
    func getFavorites() -> [Repository] {
        return getFavorites(inList: [])
    }
    
    func saveToFavorites(repository: Repository) -> Bool {
        let fetchRequest: NSFetchRequest<RepositoryDOM> = RepositoryDOM.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %i", repository.id)
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                return true
            } else {
                let new = repository.managedObject(context: context)
                context.insert(new)
            }
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    func removeFavorites(repository: Repository) -> Bool {
        let fetchRequest: NSFetchRequest<RepositoryDOM> = RepositoryDOM.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %i", repository.id)
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                context.delete(results.first!)
            }
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    func getContext() -> NSManagedObjectContext {
        return context
    }
    
}

