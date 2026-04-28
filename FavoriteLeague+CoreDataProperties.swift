//
//  FavoriteLeague+CoreDataProperties.swift
//  SportFolio
//
//  Created by TaqieAllah on 28/04/2026.
//
//

public import Foundation
public import CoreData


public typealias FavoriteLeagueCoreDataPropertiesSet = NSSet

extension FavoriteLeague {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteLeague> {
        return NSFetchRequest<FavoriteLeague>(entityName: "FavoriteLeague")
    }

    @NSManaged public var leagueKey: Int64
    @NSManaged public var leagueLogo: String?
    @NSManaged public var leagueName: String?
    @NSManaged public var sportType: String?

}

extension FavoriteLeague : Identifiable {

}
