//
//  CoreDataManager.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 28/04/2026.
//

import CoreData
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
     
        private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SportFolio")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData error: \(error)")
            }
        }
        return container
    }()
    
   
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Save error: \(error)")
            }
        }
    }
    
    
    func addFavorite(leagueKey: Int, leagueName: String, leagueLogo: String, sportType: String) {
     
        guard !isFavorite(leagueKey: leagueKey) else { return }
        
        let favorite = FavoriteLeague(context: context)
        favorite.leagueKey  = Int64(leagueKey)
        favorite.leagueName = leagueName
        favorite.leagueLogo = leagueLogo
        favorite.sportType  = sportType
        
        saveContext()
    }
    
     
    func removeFavorite(leagueKey: Int) {
        let request: NSFetchRequest<FavoriteLeague> = FavoriteLeague.fetchRequest()
        request.predicate = NSPredicate(format: "leagueKey == %d", leagueKey)
        
        do {
            let results = try context.fetch(request)
            results.forEach { context.delete($0) }
            saveContext()
        } catch {
            print("Delete error: \(error)")
        }
    }
    
  
    func getAllFavorites() -> [FavoriteLeague] {
        let request: NSFetchRequest<FavoriteLeague> = FavoriteLeague.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    
    func isFavorite(leagueKey: Int) -> Bool {
        let request: NSFetchRequest<FavoriteLeague> = FavoriteLeague.fetchRequest()
        request.predicate = NSPredicate(format: "leagueKey == %d", leagueKey)
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            return false
        }
    }
}
extension CoreDataManager: FavoritesDataSource {}
