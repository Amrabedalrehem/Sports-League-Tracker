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
    private var  filteredLeagues : [LeagueModel] = []
    private var searchWorkItem: DispatchWorkItem?
    
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
                    self.filteredLeagues = self.leagues

                    if self.filteredLeagues.isEmpty {
                        self.view?.showEmptyState()
                    } else {
                        self.view?.hideEmptyState()
                    }

                    self.view?.reloadData()
                case .failure(let error):
                    self.view?.showError(message: error.localizedDescription)
                }
            }
        }
    }
   
    func getLeaguesCount() -> Int {
        return filteredLeagues.count
    }
    
    func getLeague(at index: Int) -> LeagueModel {
        return filteredLeagues[index]
    }
    
    func isOnline() -> Bool {
        return NetworkMonitor.shared.isConnected
    }
    
    func searchLeagues(text: String) {

        searchWorkItem?.cancel()

        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }

            self.filteredLeagues = text.isEmpty
            ? self.leagues
            : self.leagues.filter {
                ($0.leagueName ?? "")
                    .lowercased()
                    .contains(text.lowercased())
            }

            DispatchQueue.main.async {

                if self.filteredLeagues.isEmpty {
                    self.view?.showEmptyState()
                } else {
                    self.view?.hideEmptyState()
                }

                self.view?.reloadData()
            }
        }

        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: workItem)
    }
    
}
