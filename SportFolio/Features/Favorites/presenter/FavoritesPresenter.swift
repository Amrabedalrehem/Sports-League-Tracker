//
//  FavoritesView.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 01/05/2026.
//


import Foundation
import Alamofire

 


 
class FavoritesPresenter {
    
    weak var view: FavoritesView?
    
    private var sections: [String] = []
    private var data: [String: [FavoriteLeague]] = [:]
    
 
    func attachView(_ view: FavoritesView) {
        self.view = view
    }
 
    func loadFavorites() {
        data     = CoreDataManager.shared.getFavoriteGroupedBySport()
        sections = Array(data.keys).sorted()
        view?.reloadData()
    }
        func getSectionsCount() -> Int {
        return sections.count
    }
    
    func getSectionTitle(at section: Int) -> String {
        return sections[section]
    }
    
   
    func getRowsCount(in section: Int) -> Int {
        let key = sections[section]
        return data[key]?.count ?? 0
    }
    
    func getFavorite(section: Int, row: Int) -> FavoriteLeague? {
        let key = sections[section]
        return data[key]?[row]
    }
    
 
    func didSelectFavorite(section: Int, row: Int) {
        guard isOnline() else {
            view?.showNoInternet()
            return
        }
 
    }
    
    func getSelectedFavorite(section: Int, row: Int) -> FavoriteLeague? {
        return getFavorite(section: section, row: row)
    }
 
    func isOnline() -> Bool {
        return NetworkMonitor.shared.isConnected
    }
}
