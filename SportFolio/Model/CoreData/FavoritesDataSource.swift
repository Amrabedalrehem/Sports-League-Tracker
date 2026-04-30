//
//  FavoritesDataSource.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 29/04/2026.
//


protocol FavoritesDataSource {
    func addFavorite(leagueKey: Int, leagueName: String, leagueLogo: String, sportType: String)
    func removeFavorite(leagueKey: Int)
    func getAllFavorites() -> [FavoriteLeague]
    func isFavorite(leagueKey: Int) -> Bool
}