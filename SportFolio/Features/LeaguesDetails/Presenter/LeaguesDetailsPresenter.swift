//
//  LeaguesDetailsPresenter.swift
//  SportFolio
// created by Shahudaaa

import Foundation

class LeaguesDetailsPresenter {

    
    private let network: NetworkService = NetworkServiceImpl.shared
    private let coreData: CoreDataManager = CoreDataManager.shared
    weak var view: LeaguesDetailsView?
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
    
    
    
    func getTeams() {

        guard let leagueId = leagueId else {
            view?.showEmptyState()
            return
        }

        view?.showLoading()

        network.getTeams(baseURL: sportType.baseURL, leagueId: leagueId) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.view?.hideLoading()

                switch result {

                case .success(let response):
                    let data = response.result ?? []
                    self.teams = data

                    if data.isEmpty {
                        self.view?.showEmptyState()
                    } else {
                        self.view?.showData()
                    }

                case .failure(let error):
                    self.view?.showError(message: error.localizedDescription)
                }
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
    
    func getEvents() {
        
        guard let leagueId = leagueId else {
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
                    let events = response.result ?? []
                    self.allEvents = events
                    
                    print("Events count:", events.count)
                    
                    if events.isEmpty {
                        self.view?.showEmptyState()
                    } else {
                        self.view?.showData()
                    }
                    
                case .failure(let error):
                    self.view?.showError(message: error.localizedDescription)
                }
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

           
            return calendar.isDate(date, inSameDayAs: now) || date > now
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

