//
//  NetworkManager.swift
//  SportFolio
//
//  Created by ITI_JETS on 28/04/2026.
//


import Foundation
protocol NetworkService {
    
    func getLeagues(
        baseURL: String,
        completion: @escaping (Result<LeaguesResponse, Error>) -> Void
    )
    
    func getEvents(
        baseURL: String,
        leagueId: Int,
        from: String,
        to: String,
        completion: @escaping (Result<EventsResponse, Error>) -> Void
    )
    
    func getTeams(
        baseURL: String,
        leagueId: Int,
        completion: @escaping (Result<TeamsResponse, Error>) -> Void
    )
    
    func getTeamDetails(
        baseURL: String,
        teamId: Int,
        completion: @escaping (Result<TeamsResponse, Error>) -> Void
    )
    
    func getPlayers(
        baseURL: String,
        leagueId: Int,
        completion: @escaping (Result<PlayerResponse, Error>) -> Void
    )

	func getPlayerDetails
	(
		baseURL: String,
		playerKey: Int,
		completion: @escaping (Result<PlayerResponse, Error>) -> Void
	)
}
class NetworkServiceImpl : NetworkService{


    
    
    static let shared = NetworkServiceImpl()
    private init() {}
    
     
    func getEvents(
        baseURL: String,
        leagueId: Int,
        from: String,
        to: String,
        completion: @escaping (Result<EventsResponse, Error>) -> Void
    ) {
        APIClient.shared.request(
            baseURL: baseURL,
            params: [
                "met": "Fixtures",
                "leagueId": leagueId,
                "from": from,
                "to": to
            ],
            responseType: EventsResponse.self,
            completion: completion
        )
    }
    
   
    func getLeagues(
        baseURL: String,
        completion: @escaping (Result<LeaguesResponse, Error>) -> Void
    ) {
        APIClient.shared.request(
            baseURL: baseURL,
            params: ["met": "Leagues"],
            responseType: LeaguesResponse.self,
            completion: completion
        )
    }
    


   
    func getTeams(
        baseURL: String,
        leagueId: Int,
        completion: @escaping (Result<TeamsResponse, Error>) -> Void
    ) {
        APIClient.shared.request(
            baseURL: baseURL,
            params: [
                "met" : "Teams",
                "leagueId" : leagueId
            ],
            responseType: TeamsResponse.self,
            completion: completion
        )
    }
    

    func getTeamDetails(
        baseURL: String,
        teamId: Int,
        completion: @escaping (Result<TeamsResponse, Error>) -> Void
    ) {
        APIClient.shared.request(
            baseURL: baseURL,
            params: [
                "met" : "Teams",
                "teamId" : teamId
            ],
            responseType: TeamsResponse.self,
            completion: completion
        )
    }
    
    
    func getPlayers(
        baseURL: String,
        leagueId: Int,
        completion: @escaping (Result<PlayerResponse, Error>) -> Void
    ) {
        APIClient.shared.request(
            baseURL: baseURL,
            params: [
                "met": "Players",
                "leagueId": leagueId
            ],
            responseType: PlayerResponse.self,
            completion: completion
        )
    }

	func getPlayerDetails(
		baseURL: String,
		playerKey: Int,
		completion: @escaping (Result<PlayerResponse, any Error>) -> Void
	) {
		APIClient.shared
			.request(
				baseURL: baseURL,
				params: ["met": "Players"],
				responseType: PlayerResponse.self,
				completion:completion
			)
	}
}
