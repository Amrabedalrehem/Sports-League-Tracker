//
//  SportsView.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 29/04/2026.
//
import Alamofire

class SportsPresenter {

    weak var view: ViewController?

    private let sports: [SportModel] = [
        SportModel(name: "Football", image: "Football", baseURL: APIConstants.BaseURL.football,sportType: .football),
        SportModel(name: "Basketball", image: "Basketball", baseURL: APIConstants.BaseURL.basketball,sportType: .basketball),
        SportModel(name: "Cricket", image: "Cricket", baseURL: APIConstants.BaseURL.cricket,sportType: .cricket),
        SportModel(name: "Tennis", image: "Tennis", baseURL: APIConstants.BaseURL.tennis,sportType: .tennis)
    ]

    func attachView(_ view: ViewController) {
        self.view = view
        self.view?.reloadData()
    }

    func getSportsCount() -> Int {
        sports.count
    }

    func getSport(at index: Int) -> SportModel {
        sports[index]
    }

    func didSelectSport(at index: Int) -> SportModel {
        sports[index]
    }
    func isOnline() -> Bool {
        return NetworkMonitor.shared.isConnected
    }
    
    
}
