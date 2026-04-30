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
                    print(data.count)
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
                    let now = Date()
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    
                    var upcoming: [EventModel] = []
                    var last: [EventModel] = []
                    
                    for event in events {
                        
                        guard let dateStr = event.eventDate,
                              let eventDate = formatter.date(from: dateStr) else {
                            continue
                        }
                        
                        switch self.sportType {
                            
                        case .football:
                            if eventDate >= now {
                                upcoming.append(event)
                            } else {
                                last.append(event)
                            }
                            
                        case .basketball, .tennis, .cricket:
                            if event.eventStatus?.lowercased() == "finished" {
                                last.append(event)
                            } else {
                                upcoming.append(event)
                            }
                        }
                    }
                    
                    self.upcomingEvents = upcoming
                    self.lastEvents = last
                    
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
