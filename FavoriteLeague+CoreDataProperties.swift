//
//  FavoriteLeague+CoreDataProperties.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 02/05/2026.
//
//

import Foundation
import CoreData


extension FavoriteLeague {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteLeague> {
        return NSFetchRequest<FavoriteLeague>(entityName: "FavoriteLeague")
    }

    @NSManaged public var leagueKey: Int64
    @NSManaged public var leagueLogo: String?
    @NSManaged public var leagueName: String?
    @NSManaged public var sportType: String?
    @NSManaged public var leagueCountry: String?

}

extension FavoriteLeague : Identifiable {

}
