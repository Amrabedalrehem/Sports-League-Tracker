//
//  LeaguesDetailsPresenter.swift
//  SportFolio
// created by Shahudaaa

import Foundation
protocol LeaguesDetailsPresenterProtocol {
    
    func getItems()
    func getNumberOfItems() -> Int
    func getNumberOfTeams() -> Int
    func getNumberOfPlayers() -> Int
    func getTeamItem(at index: Int) -> LeagueItem
    func getPlayerItem(at index: Int) -> LeagueItem
    func getEvents()
    func getNumberOfUpcomingEvents() -> Int
    func getNumberOfLatestEvents() -> Int
    func getUpcomingEvent(at index: Int) -> EventModel
    func getLatestEvent(at index: Int) -> EventModel
    func getLatestEvents() -> [EventModel]
    func addToFavorites()
    func removeFromFavorites()
    func isFavorite() -> Bool
    func toggleFavorite() -> Bool
    func getBaseURL() -> String
    func getSportType () -> SportType
    func getLeagueName() ->String
}
class LeaguesDetailsPresenter: LeaguesDetailsPresenterProtocol {

    private let network: NetworkService
    private let coreData: CoreDataManager
    weak var view: LeaguesDetailsView?
    var league: LeagueModel?
    private let sportType: SportType
    private var allEvents: [EventModel] = []
    private var teams: [TeamModel] = []
    private var players: [PlayerModel] = []
  
     
    init(sportType: SportType, league: LeagueModel? = nil,network: NetworkService, coreData: CoreDataManager) {
        self.sportType = sportType
        self.league = league
        self.network = network
        self.coreData = coreData
        
    }
}

extension LeaguesDetailsPresenter {

    func getItems() {
        guard let leagueId = league?.leagueKey else {
            view?.showEmptyState()
            return
        }

        view?.showLoading()
        let group = DispatchGroup()
        
        group.enter()
        network.getTeams(baseURL: sportType.baseURL, leagueId: leagueId) { [weak self] result in
            guard let self = self else { group.leave(); return }
            if case .success(let response) = result {
                self.teams = response.result ?? []
            }
            group.leave()
        }

        group.enter()
        network.getPlayers(baseURL: sportType.baseURL, leagueId: leagueId) { [weak self] result in
            guard let self = self else { group.leave(); return }
            if case .success(let response) = result {
                self.players = response.result ?? []
            }
            group.leave()
        }

        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.view?.hideLoading()
            if self.teams.isEmpty && self.players.isEmpty {
                self.view?.showEmptyState()
            } else {
                self.view?.showData()
            }
        }
    }

    func getNumberOfItems() -> Int {
        return sportType == .tennis ? players.count : teams.count
    }

   

    func getNumberOfTeams() -> Int { return teams.count }
    func getNumberOfPlayers() -> Int { return players.count }

    func getTeamItem(at index: Int) -> LeagueItem { return .team(teams[index]) }
    func getPlayerItem(at index: Int) -> LeagueItem { return .player(players[index]) }

    func getBaseURL() -> String {
        return sportType.baseURL
    }
    
    func getSportType () -> SportType{
        return sportType
    }
}

extension LeaguesDetailsPresenter {

    private func parseDate(_ string: String?) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return string.flatMap { formatter.date(from: $0) }
    }

    private func getDateRange() -> (from: String, to: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let calendar = Calendar.current
        let today = Date()

        let fromDate = calendar.date(byAdding: .month, value: -6, to: today)!
        let toDate = calendar.date(byAdding: .month, value: 6, to: today)!

        return (formatter.string(from: fromDate),
                formatter.string(from: toDate))
    }

    func getEvents() {
        
        guard let leagueId = league?.leagueKey else {
            view?.showEmptyState()
            return
        }

        let range = getDateRange()
        view?.showLoading()

        network.getEvents(
            baseURL: sportType.baseURL,
            leagueId: leagueId,
            from: range.from,
            to: range.to
        ) { [weak self] result in

            guard let self = self else { return }

            DispatchQueue.main.async {
                self.view?.hideLoading()

                switch result {
                case .success(let response):
                    self.allEvents = response.result ?? []
                    self.allEvents.isEmpty ? self.view?.showEmptyState() : self.view?.showData()

                case .failure(let error):
                    self.view?.showError(message: error.localizedDescription)
                }
            }
        }
    }

    func getUpcomingEvents() -> [EventModel] {
        let now = Date()
        let calendar = Calendar.current

        return allEvents.filter {
            let status = $0.eventStatus?.lowercased() ?? ""
            if status == "finished" { return false }

            guard let date = parseDate($0.eventDate) else { return true }
            return calendar.isDate(date, inSameDayAs: now) || date > now
        }
    }

    func getLatestEvents() -> [EventModel] {
        let now = Date()
        let calendar = Calendar.current

        return allEvents.filter {
            let status = $0.eventStatus?.lowercased() ?? ""
            if status == "finished" { return true }

            guard let date = parseDate($0.eventDate) else { return false }
            return date < now && !calendar.isDate(date, inSameDayAs: now)
        }
    }

    func getNumberOfUpcomingEvents() -> Int {
        return getUpcomingEvents().count
    }

    func getNumberOfLatestEvents() -> Int {
        return getLatestEvents().count
    }

    func getUpcomingEvent(at index: Int) -> EventModel {
        return getUpcomingEvents()[index]
    }

    func getLatestEvent(at index: Int) -> EventModel {
        return getLatestEvents()[index]
    }
}

extension LeaguesDetailsPresenter {
    
  
    func addToFavorites() {

        guard let league = league else { return }

        coreData.addFavorite(
            leagueModel: league, sportsType: sportType.rawValue
        )
    }
    func removeFromFavorites() {

        guard let leagueKey = league?.leagueKey else { return }

        coreData.removeFavorite(leagueKey: Int64(leagueKey))
    }

    func isFavorite() -> Bool {

        guard let leagueKey = league?.leagueKey else { return false }

        return coreData.isFavorite(leagueKey:  Int64(leagueKey))
    }
    
    

    

}

extension LeaguesDetailsPresenter{
    func toggleFavorite() -> Bool {
        
        if isFavorite() {
            removeFromFavorites()
            return false
        } else {
            addToFavorites()
            return true
        }
    }
    
    
    func isOnline() -> Bool {
        return NetworkMonitor.shared.isConnected
    }
    
    func getLeagueName() ->String{
        return league?.leagueName ?? ""
    }
}
