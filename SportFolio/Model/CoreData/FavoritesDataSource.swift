//
//  FavoritesDataSource.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 29/04/2026.
//


protocol FavoritesDataSource {
    func addFavorite(leagueModel: LeagueModel, sportsType: String)
    func removeFavorite(leagueKey: Int64)
    func getAllFavorites() -> [FavoriteLeague]
    func isFavorite(leagueKey: Int64) -> Bool
    func getFavoriteGroupedBySport() -> [String: [FavoriteLeague]]

}
