//
//  LeaguesDetailsPresenter.swift
//  SportFolio
// created by Shahudaaa

import Foundation

class LeaguesDetailsPresenter {

    
    private let network: NetworkService = NetworkServiceImpl.shared
    private let coreData: CoreDataManager = CoreDataManager.shared
    var leagueId: Int?
    private let sportType: SportType
    private var allEvents: [EventModel] = []
    private var teams: [TeamModel] = []
    
    
    init(sportType: SportType, leagueId: Int? = nil) {
        self.sportType = sportType
        self.leagueId = leagueId
    }
}


extension LeaguesDetailsPresenter {

    func getTeams(completion: @escaping ([TeamModel]) -> Void) {

        guard let leagueId = leagueId else {
            completion([])
            return
        }

        network.getTeams(baseURL: sportType.baseURL,leagueId: leagueId) { [weak self] result in

            switch result {
            case .success(let response):
                let data = response.result ?? []
                self?.teams = data
                completion(data)

            case .failure(let error):
                print("Teams Error:", error.localizedDescription)
                completion([])
            }
        }
    }

    func getNumberOfTeams() -> Int {
        return teams.count
    }

    func getTeam(at index: Int) -> TeamModel {
        return teams[index]
    }
}

extension LeaguesDetailsPresenter {

    private func parseDate(_ string: String?) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return string.flatMap { formatter.date(from: $0) }
    }

    private func isTodayOrFuture(_ date: Date, now: Date, calendar: Calendar) -> Bool {
        return calendar.isDate(date, inSameDayAs: now) || date > now
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
    
        func getEvents(completion: @escaping ([EventModel]) -> Void) {

            guard let leagueId = leagueId else {
                completion([])
                return
            }

            let range = getDateRange()

            network.getEvents(
                baseURL: sportType.baseURL,
                leagueId: leagueId,
                from: range.from,
                to: range.to
            ) { [weak self] result in

                switch result {

                case .success(let response):
                    let events = response.result ?? []
                    self?.allEvents = events
                    completion(events)

                case .failure(let error):
                    print("Events Error:", error.localizedDescription)
                    completion([])
                }
            }
        }

   

    func getUpcomingEvents() -> [EventModel] {

        let now = Date()
        let calendar = Calendar.current

        return allEvents.filter { event in

            let status = event.eventStatus?.lowercased() ?? ""

          
            if status == "finished" {
                return false
            }

            guard let date = parseDate(event.eventDate) else {
                return true
            }

            if sportType == .football {
                return isTodayOrFuture(date, now: now, calendar: calendar)
            }

            return true
        }
    }


    func getLatestEvents() -> [EventModel] {

        let now = Date()
        let calendar = Calendar.current

        return allEvents.filter { event in

            let status = event.eventStatus?.lowercased() ?? ""

          
            if status == "finished" {
                return true
            }

            guard let date = parseDate(event.eventDate) else {
                return false
            }

            if sportType == .football {
                return date < now && !calendar.isDate(date, inSameDayAs: now)
            }

            return false
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

    func addToFavorites(team: TeamModel) {
        guard let key = team.teamKey else { return }

        coreData.addFavorite(
            leagueKey: key,
            leagueName: team.teamName ?? "",
            leagueLogo: team.teamLogo ?? "",
            sportType: sportType.baseURL
        )
    }

    func removeFromFavorites(team: TeamModel) {
        guard let key = team.teamKey else { return }
        coreData.removeFavorite(leagueKey: key)
    }

    func isFavorite(team: TeamModel) -> Bool {
        guard let key = team.teamKey else { return false }
        return coreData.isFavorite(leagueKey: key)
    }
}

