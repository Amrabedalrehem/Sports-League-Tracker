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
    
    
    func addFavorite(leagueModel: LeagueModel,sportsType: String) {
     
        guard !isFavorite(leagueKey: leagueModel.leagueKey.toInt64()) else { return }
        
        let favorite = FavoriteLeague(context: context)
        favorite.leagueKey  = leagueModel.leagueKey.toInt64()
        favorite.leagueName = leagueModel.leagueName
        favorite.leagueLogo = leagueModel.leagueLogo
        favorite.sportType  = sportsType
        favorite.leagueCountry = leagueModel.countryName
        
        saveContext()
    }
    
     
    func removeFavorite(leagueKey: Int64) {
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
    
    
    func isFavorite(leagueKey: Int64) -> Bool {
        let request: NSFetchRequest<FavoriteLeague> = FavoriteLeague.fetchRequest()
        request.predicate = NSPredicate(format: "leagueKey == %d", leagueKey)
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            return false
        }
    }
    
    func getFavoriteGroupedBySport() -> [String: [FavoriteLeague]] {
        let all = getAllFavorites()
        return Dictionary(grouping: all) { $0.sportType ?? "" }
    }
    
}
extension CoreDataManager: FavoritesDataSource {
   
    
   
}
 
extension Int? {
    func toInt64() -> Int64 {
        return Int64(self ?? 0)
    }
}
extension Int64{
    func toInt() -> Int {
        Int(self)
    }
}
