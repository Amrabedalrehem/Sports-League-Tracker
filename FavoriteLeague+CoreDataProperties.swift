//
//  FavoriteLeague+CoreDataProperties.swift
//  SportFolio
//
//  Created by ITI_JETS on 28/04/2026.
//
//

import Foundation
import CoreData


extension FavoriteLeague {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteLeague> {
        return NSFetchRequest<FavoriteLeague>(entityName: "FavoriteLeague")
    }

    @NSManaged public var leagueKey: Int64
    @NSManaged public var leagueName: String?
    @NSManaged public var sportType: String?
    @NSManaged public var leagueLogo: String?

}

extension FavoriteLeague : Identifiable {

}
