//
//  LeaguesDetailsPresenter.swift
//  SportFolio
//
//  Created by ITI_JETS on 30/04/2026.
//

import Foundation

class DetailsLeaguePresenter {
    
    private let network: NetworkService = NetworkServiceImpl.shared
    
    private let coreData: CoreDataManager = CoreDataManager.shared
    
    
    var teams: [TeamModel] = []
    var upcomingEvents: [EventModel] = []
    var lastEvents: [EventModel] = []
    var sportType: SportType = .football
     
  
            func getTeams(
            leagueId: Int,
            completion: @escaping ([TeamModel]) -> Void
        ) {
            network.getTeams(
                baseURL: sportType.baseURL,
                leagueId: leagueId
            ) { [weak self] result in
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
    func getEvents(
        leagueId: Int,
        from: String,
        to: String,
        completion: @escaping (_ upcoming: [EventModel], _ last: [EventModel]) -> Void
    ) {
        network.getEvents(
            baseURL: sportType.baseURL,
            leagueId: leagueId,
            from: from,
            to: to
        ) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                
                let events = response.result ?? []
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                
                let now = Date()
                let calendar = Calendar.current
                
                var upcoming: [EventModel] = []
                var last: [EventModel] = []
                
                for event in events {
                    
                    let status = event.eventStatus?.lowercased() ?? ""
                    
                    if status == "finished" {
                        last.append(event)
                        continue
                    }
                    
                    if let dateStr = event.eventDate,
                       let eventDate = formatter.date(from: dateStr) {
                        
                        switch self.sportType {
                            
                        case .football:
                            if calendar.isDate(eventDate, inSameDayAs: now) || eventDate > now {
                                upcoming.append(event)
                            } else {
                                last.append(event)
                            }
                            
                        case .basketball, .tennis, .cricket:
                            upcoming.append(event)
                        }
                        
                    } else {
                    
                        upcoming.append(event)
                    }
                }
                
                self.upcomingEvents = upcoming
                self.lastEvents = last
                
                print("Upcoming:", upcoming.count)
                print("Last:", last.count)
                
                completion(upcoming, last)
                
            case .failure(let error):
                print("Events Error:", error.localizedDescription)
                completion([], [])
            }
        }
    }
    func getNumberOfUpcomingEvents ()  -> Int {
        return upcomingEvents.count
    }
    
    func getNumberOfLatestEvents() -> Int {
        return lastEvents.count
    }
        
    func getUpcomingEvent(at index: Int) -> EventModel? {
        return upcomingEvents[index]
    }
    
    func getLatestEvent(at index: Int) -> EventModel? {
        return lastEvents[index]
    }
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
