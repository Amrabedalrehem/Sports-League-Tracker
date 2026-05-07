//
//  LeaguesDetailsPresenter.swift
//  SportFolio
//  created by Shahudaaa
//

import Foundation

protocol LeaguesDetailsPresenterProtocol {
    
    func loadAllData()
    func getNumberOfItems() -> Int
    func getNumberOfTeams() -> Int
    func getNumberOfPlayers() -> Int
    func getTeamItem(at index: Int) -> LeagueItem
    func getPlayerItem(at index: Int) -> LeagueItem
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
    func getSportType() -> SportType
    func getLeagueName() -> String
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
    init(sportType: SportType,league: LeagueModel? = nil,network: NetworkService,coreData: CoreDataManager) {
        self.sportType = sportType
        self.league = league
        self.network = network
        self.coreData = coreData
    }
}

extension LeaguesDetailsPresenter {

    func loadAllData() {

        guard let leagueId = league?.leagueKey else {
            view?.showEmptyState()
            return
        }

        view?.showLoading()

        let group = DispatchGroup()

        group.enter()
        fetchTeams(leagueId: leagueId) {
            group.leave()
        }

        group.enter()
        fetchPlayers(leagueId: leagueId) {
            group.leave()
        }

        group.enter()
        fetchEvents(leagueId: leagueId) {
            group.leave()
        }

        group.notify(queue: .main) { [weak self] in

            guard let self = self else { return }

            self.view?.hideLoading()

            let hasData =
                !self.teams.isEmpty ||
                !self.players.isEmpty ||
                !self.allEvents.isEmpty

            if hasData {
                self.view?.showData()
            } else {
                self.view?.showEmptyState()
            }
        }
    }
}


extension LeaguesDetailsPresenter {

    private func fetchTeams(
        leagueId: Int,
        completion: @escaping () -> Void
    ) {

        network.getTeams(
            baseURL: sportType.baseURL,
            leagueId: leagueId
        ) { [weak self] result in defer { completion() }
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.teams = response.result ?? []
            case .failure(let error):
                DispatchQueue.main.async {
                    self.view?.showError(
                        message: error.localizedDescription
                    )
                }
            }
        }
    }

    private func fetchPlayers(leagueId: Int,completion: @escaping () -> Void) {

        network.getPlayers(baseURL: sportType.baseURL,leagueId: leagueId) { [weak self] result in

            defer { completion() }
            guard let self = self else { return }
            switch result {

            case .success(let response):
               self.players = response.result ?? []

            case .failure(let error):

                DispatchQueue.main.async {
                    self.view?.showError(
                        message: error.localizedDescription
                    )
                }
            }
        }
    }

    private func fetchEvents(leagueId: Int,completion: @escaping () -> Void) {

        let range = getDateRange()

        network.getEvents(baseURL: sportType.baseURL,leagueId: leagueId,from: range.from,to: range.to) { [weak self] result in

            defer { completion() }
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.allEvents = response.result ?? []
            case .failure(let error):

                DispatchQueue.main.async {
                    self.view?.showError(
                        message: error.localizedDescription
                    )
                }
            }
        }
    }
}


extension LeaguesDetailsPresenter {

    func getNumberOfItems() -> Int {return sportType == .tennis ? players.count: teams.count
    }

    func getNumberOfTeams() -> Int {
        return teams.count
    }

    func getNumberOfPlayers() -> Int {
        return players.count
    }

    func getTeamItem(at index: Int) -> LeagueItem {
        return .team(teams[index])
    }

    func getPlayerItem(at index: Int) -> LeagueItem {
        return .player(players[index])
    }

    func getBaseURL() -> String {
        return sportType.baseURL
    }

    func getSportType() -> SportType {
        return sportType
    }

    func getLeagueName() -> String {
        return league?.leagueName ?? ""
    }
}



extension LeaguesDetailsPresenter {

    private func parseDate(_ string: String?) -> Date? {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return string.flatMap {
            formatter.date(from: $0)
        }
    }

    private func getDateRange() -> (from: String, to: String) {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let calendar = Calendar.current
        let today = Date()

        let monthsRange: Int

        switch sportType {

        case .football:
            monthsRange = 3

        case .basketball:
            monthsRange = 6

        case .cricket, .tennis:
            monthsRange = 12
        }

        let fromDate = calendar.date(
            byAdding: .month,
            value: -monthsRange,
            to: today
        )!

        let toDate = calendar.date(
            byAdding: .month,
            value: monthsRange,
            to: today
        )!

        return (
            formatter.string(from: fromDate),
            formatter.string(from: toDate)
        )
    }

    func getUpcomingEvents() -> [EventModel] {

        let now = Date()
        let calendar = Calendar.current

        return allEvents.filter {

            let status = $0.eventStatus?.lowercased() ?? ""

            if status == "finished" {
                return false
            }

            guard let date = parseDate($0.eventDate)
            else { return true }

            return calendar.isDate(date, inSameDayAs: now) || date > now
        }
    }

    func getLatestEvents() -> [EventModel] {

        let now = Date()
        let calendar = Calendar.current

        return allEvents.filter {

            let status = $0.eventStatus?.lowercased() ?? ""

            if status == "finished" {
                return true
            }

            guard let date = parseDate($0.eventDate)
            else { return false }

            return date < now &&
            !calendar.isDate(date, inSameDayAs: now)
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
            leagueModel: league,
            sportsType: sportType.rawValue
        )
    }

    func removeFromFavorites() {

        guard let leagueKey = league?.leagueKey else {
            return
        }

        coreData.removeFavorite(
            leagueKey: Int64(leagueKey)
        )
    }

    func isFavorite() -> Bool {

        guard let leagueKey = league?.leagueKey else {
            return false
        }

        return coreData.isFavorite(
            leagueKey: Int64(leagueKey)
        )
    }

    func toggleFavorite() -> Bool {

        if isFavorite() {

            removeFromFavorites()
            return false

        } else {

            addToFavorites()
            return true
        }
    }
}


extension LeaguesDetailsPresenter {

    func isOnline() -> Bool {
        return NetworkMonitor.shared.isConnected
    }
}
