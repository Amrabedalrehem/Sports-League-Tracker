//
//  LeaguesPresenter.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 30/04/2026.
//

import Foundation
 
 
class LeaguesPresenter {
    
 
    weak var view: LeaguesView?
    private var leagues: [LeagueModel] = []
    
    var sportType :SportType?
 
    init( sportType: SportType? = nil) {
    
        self.sportType = sportType
    }
    func attachView(_ view: LeaguesView) {
        self.view = view
    }
  
    func fetchLeagues() {
          if !isOnline() {
            view?.showNoInternet()
            return
        }

          view?.startAnimating()
        
        NetworkServiceImpl.shared.getLeagues(baseURL: sportType!.baseURL) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.view?.stopAnimating()
                
                switch result {
                case .success(let response):
                    self.leagues = response.result ?? []
                    self.view?.reloadData()
                case .failure(let error):
                    self.view?.showError(message: error.localizedDescription)
                }
            }
        }
    }
   
    func getLeaguesCount() -> Int {
        return leagues.count
    }
    
    func getLeague(at index: Int) -> LeagueModel {
        return leagues[index]
    }
    
    func isOnline() -> Bool {
        return NetworkMonitor.shared.isConnected
    }
    
 
    
}
